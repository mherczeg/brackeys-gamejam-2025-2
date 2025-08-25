---
title: Day 1 - Plans and Dreams
date: 2025-08-25 10:26:13
tags:
---

Okay, the following is the result of about two hours of very targeted brainstorming. Time to get coding.

High level:

- I'll aim to get the core gameplay loop going by EOD Wednesday.
- Thursday-Friday I'll try to keep as art days, get the audio-visuals in place.
- Saturday-Sunday is for testing, fixes, and small improvements.

Core gameplay days:

- Day 1 I want the core mixing UI/gameplay in place.
- All other efforts day 1 I want to spend on organizing my thoughts/ideas, document all my system ideas.
- Day 2 I want to implement whatever I come up with for the customers.
- Day 3 Link the two systems, and fill the content (names and description).

Art Days:

- For now the plan is to try not to think about it. I'll solve it when I get there. (This means a whole lot of rectangles for Days 1-3)
- Sound is just going to be whatever royalty free stuff I can find. There are no other options even worth considering
- Visuals are going to be a lot of asset packs, and stock photos with a pixelart filter.


Core gameplay loop (I'm just brainstorming, this will likely be reduced to what is achievable):

1. An NPC or group of NPCs appear on screen conversing
    - They have names, and descriptions
        - But since our hero is a gremlin, they names customers by what they see and hear, like "Bitchy Cyclist Guy" and "Fat Goth Hates Wanessa"
        - Descriptions are very basic by default: look, and later purchase history
        - Name could be editable for the players enjoyment
    - Return customers are recognized by consistent naming, and their description grows
        - Only the purchase history is automatic, everything else needs to be added manually by players who care/deduce correctly: likes/dislikes/allergies/etc
    - Conversation often include context clues to NPCs likes/dislikes/allergies in terms of ingredients.
        - QoL feature is to right-click a word in conversation, and save it to description
2. An NPC or group of NPCs approach the machine and place an order (they may still be conversing)
    - Their order clearly defines the recipe for the mixture, deducing it is not part of the game
3. The gremlin mixes their drink (but also: ramen, gum, candy bar, etc)
    - They select the base (soft drink, ramen, etc)
    - They add ingredients to product the correct drink, like Cola, Fanta, Coffee, Mineral/Still water.
    - At this point they may send the mixture on it's way.
        - If it satisfies the order, they get good points (TODO: figure theme out for this later. Management approval? Yelp Rating?), if it isn't they get bad points.
        - They have options to produce things which does more than the recipe. Customer ask for a drink, but they have likes/dislikes/allergies.
            - A person may appear with their boss for example or with someone they wish to impress, and ask for a serious drink (like a sour drink), but the gremlin know they like other ingredients, and add that as well (making their sour drink more sweet than sour) 
            - The gremlin could choose to provide an unsatisfactory drink to save someone from their allergy
            - Or let's say someone is rude and/or abusive to someone else, the gremlin could trigger their allergy
            - This is very stretch, but we are reaching the point of having quests in the game, like a crime boss becomes a regular, and the gremlin has to learn their taste to poison them
        - They should also have abilities to do further things her:
            - Like the rare second drop: a second, free drink
            - Or just taking their money and refusing to serve (which actually has tactical utility, if ingredients cost money)
4. The customer(s) leave with another conversation snippet.
5. Repeat until refill day
6. On refill day earned currencies can be spent to restock ingredients, buy new unknown ingredients, unlock new bases, maybe some other perks.
7. Repeat until win condition (TODO: what's the win condition. Could be just mastering all ingredients, and then endless mode, but with the risk gone, this prototype will become stale).


With that out of the way, today's focus is mixing:

- A product is a base + min 2, max 4 ingredients. 
- At least 2 of the same effect on an ingredient activates.
- 3 and 4 matches provide bigger and stronger effects.
- Do we limit the effects on the final product to 4? Theoretical limit is 8 right now.
    - Could be an upgrade to have more than 4 effects on a product.
    - Could also be an upgrade to have more ingredients actually, start the game with just 2 or 3
- Effects have antithesis, between the two the larger one overpowers the lower one (for example carbonated, and decardonated).
    - or maybe we have groups, and within groups only the largest effect can be active?
    - or maybe some of them mix? like red food coloring and blue food coloring produces purple food coloring.
- Ingredients should be semi-randomized at the start of the game, for replayability: we have actually a list of ingredients, but their icon/image, name, and description is generated randomly assigned, otherwise players would quickly learn/google what pixie-dust does for example.
  - I think the effect list does not need obfuscation. If players correctly deduce between two half discovered ingredient, which one is which, and what are the unknown effects, that's just player skill. They are allowed to be good at the game.
- Questions to consider:
    - *How many ingredients?* Morrowind had 72 but that seems like a lot, aim for 50 for now, and we'll see if the gameplay requires more/fewer.
    - *How many products?* 10-to-20 seems a good baseline
    - *How frequent should reliance on unknown ingredients be?* People could stick to safe recipes only, is that ok/not ok? Do we design against it?
      - Incentivize: if using unknown ingredients is actually desirable, the player will do so just because they want it. Possible fluff: They are a gremlin. Gremlins are innately creatures fo chaos They could just unlock gremlin powers by feeding chaos (using unknown ingredients)
        - Pro: more player agency, they are still able to enjoy the game in whatever style they want
        - Con: we need to be careful not to imbalance it. Basically we need to avoid the game devolving into just producing random mixtures, to farm gremlin powers
      - Force them out of the safe recipe zone: this needs more brainstorming, but what if we don't purchase ingredients, we purchase ingredient producers (like a pixie in a cage for pixiedust or a tree for a leaf/flower). If the producers production cycle is low enough, players are forced to look for alternate ingredients 
        - Pro: makes sure the player plays the game the way we envisioned
        - Con: this is the sick method, and I'm vary of the stick method, because if it does not work, it's more likely that the whole design crumbles. much prefer the carrot if possible, it fails more gracefully.
      - A compromise: as I verbalized Pros and Cons of the above two approach I started to like parts of both. Maybe we compromise? We restrict production, but not by that much, and add gremlin upgrades? That's a whole new game system though. So lets just go with buying bulks of ingredients first, and we can add producers later. 
- Just theme the ingredients whatever for now, we will fill the content later.

