---
title: idea-todo
tags:
---

- Do bases have attributes?
- missing from mixing: There are no unknown effects, nor effect discovery, which is the whole point of the game. The "Mix It" button does not actually do anything. The same ingredient can be selected multiple times, and the ingredient list actually just includes every possible ingredient, there is no inventory or similar. It would be nice to sort them better as well...
- Hardcoded effects and bases for now, which is fine, but ingredients may need a scrambler


- Art: just spend half a day tracing a cityscape in asperite, who cares. antoher half a day for a gremlin sitting in a vending machine, maybe a little more time on a notebook popping up for the tools
- The icons can be assets very easily, and the machine theme works well for borders and such.

- speech bubble tileset
https://opengameart.org/content/pixel-speech-bubbles
https://www.youtube.com/watch?v=1DRy5An_6DU
https://old.reddit.com/r/godot/comments/1987kn4/how_do_i_make_text_that_shows_up_letter_by_letter/
https://www.youtube.com/watch?v=Q9Ytsd2fa5g


Day 2 plan

Original notes:

2. An NPC or group of NPCs approach the machine and place an order (they may still be conversing)
    - Their order clearly defines the recipe for the mixture, deducing it is not part of the game

Step 1.
- a customer is just a resource
- a product is just a resource 
- the game iterates through encounters
- the encounter picks 
    - a number of NPCs (weighted)
    - wether they are new or not (weighted)
    - each NPC makes an order (or not, weighted)
- at the 3 steps they have a short speech bubble, with empty text

Step 2. 
- they have likes, dislikes, and allergies now. also 2 names, and internal (what they may refer to eachother as) and external (gremlin name)
- the encounter now has a story.
    - a story is a number of speech bubbles appearing over the N characters
- story is just a resource, it has a set number of participants, which we tailor to the scene
    - a story will define what it communicates for which participant, and wildcards that into the text

 Option two: pre-generate NPC's and encounters. Thi might be faster

NPC is a resource
Encounter is a resource.
Product is still a resource, but now maybe hardcoded into encounter?
Game picks random encounter and plays it   

