---
title: Scoping Down Day
date: 2025-08-26 09:30:40
tags:
---

I spent a lot of time yesterday thinking about the "customers" part of the game. 

This was the initial design from Day 1:

> 2. An NPC or group of NPCs approach the machine and place an order (they may still be conversing)
    - Their order clearly defines the recipe for the mixture, deducing it is not part of the game


So in my head this was like: ok, we generate this whole thing randomly by a predefined pool and that's it. But looking into it: 
- we generate a random person or persons, each with an order, likes and dislikes. 
- we add "caching" for return customers
- we generate a random conversation that is linked to each person and each like/dislike in the scene

Each of these generates have a lot of complexity, and starts to sound suspiciously a lot like a story generator. Which takes a long time to do.
And the only purpose it serves is to make the game replayable.

I think it is important to set some expectations here: the majority of the players will spend a few minutes trying this thing out. A few will play it through. Replayability is not a concern.

So I scoped it down. 

Today we are going to add:
- NPCs/customers, which is going to be a set predefined list
- Products, which was always going to be a predefined list
- Encounters, which will be predefined conversations between predefined NPCs, while ordering predefined products

The only random generation will be picking a random encounter, and then moving on to the next one.

I'll also try to commit more frequently today. Yesterday I did the whole day in one commit, and that's a terrible habit to get into

![day-1-commit.png](/images/day-1-commit.png)
