pragma solidity^= uint(sha3(block.coinbase, block.blockhash(block.number - 1), seeda, seedb));

    // adjust the second phase seed for the next iteration
    seedb = (seedb * LEHMER_MUL) % LEHMER_MOD;
  }

  // pick a random winner when the time is right
  function pickWinner() private {
    // do we have >222 players or >= 5 tickets and an expired timer
    if ((numplayers >= CONFIG_MAX_PLAYERS ) || ((numplayers >= CONFIG_MIN_PLAYERS ) && (now > end))) {
      // get the winner based on the number of tickets (each player has multiple tickets)
      uint winidx = tickets[random % numtickets];
      uint output = numtickets * CONFIG_RETURN;

      // send the winnings to the winner and let the world know
      players[winidx].call.value(output)();
      notifyWinner(players[winidx], output);

      // reset the round, and start a new one
      numplayers = 0;
      numtickets = 0;
      start = now;
      end = start + CONFIG_DURATION;
      round++;
    }
  }

  // allocate tickets to the entry based on the value of the transaction
  function allocateTickets(uint number) private {
    // the last index of the ticket we will be adding to the pool
    uint ticketmax = numtickets + number;

    // loop through and allocate a ticket based on the number bought
    for (uint idx = numtickets; idx < ticketmax; idx++) {
      tickets[idx] = uint8(numplayers);
    }

    // our new value of total tickets (for this round) is the same as max, store it
    numtickets = ticketmax;

    // store the actual player info so we can reference it from the tickets
    players[numplayers] = msg.sender;
    numplayers++;

    // let the world know that we have yet another player
    notifyPlayer(number);
  }

  // we only have a default function, send an amount and it gets allocated, no ABI needed
  function() public {
    // oops, we need at least 10 finney to play :(
    if (msg.value < CONFIG_MIN_VALUE) {
      throw;
    }

    // adjust the random value based on the pseudo rndom inputs
    randomize();

    // pick a winner at the end of a round
    pickWinner();

    // here we store the number of tickets in this transaction
    uint number = 0;

    // get either a max number based on the over-the-top entry or calculate based on inputs
    if (msg.value >= CONFIG_MAX_VALUE) {
      number = CONFIG_MAX_TICKETS;
    } else {
      number = msg.value / CONFIG_PRICE;
    }

    // overflow is the value to be returned, >max or not a multiple of min
    uint input = number * CONFIG_PRICE;
    uint overflow = msg.value - input;

    // store the actual turnover, transaction increment and total tickets
    turnover += input;
    tktotal += number;
    txs += 1;

    // allocate the actual tickets now
    allocateTickets(number);

    // send back the overflow where applicable
    if (overflow > 0) {
      msg.sender.call.value(overflow)();
    }
  }

  // log events
  event Player(address addr, uint32 at, uint32 round, uint32 tickets, uint32 numtickets, uint tktotal, uint turnover);
  event Winner(address addr, uint32 at, uint32 round, uint32 numtickets, uint output);

  // notify that a new player has entered the fray
  function notifyPlayer(uint number) private {
    Player(msg.sender, uint32(now), uint32(round), uint32(number), uint32(numtickets), tktotal, turnover);
  }

  // create the Winner event and send it
  function notifyWinner(address addr, uint output) private {
    Winner(addr, uint32(now), uint32(round), uint32(numtickets), output);
  }
}