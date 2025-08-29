---
title: Penultimate Problems
date: 2025-08-29 10:46:37
tags:
---


I didn't do an end-of-day post yesterday, because I was still pushing around pixels past midnight, and then I went straight to bed.

So, not gonna lie, there was a short time around 3pm where I was just gonna quit. Nothing was working, and I had a hard time translating what is in my head to the screen, with the skills I had.
Eventually stubbornness prevailed though, so we're chugging on. 

This is actually from around 10pm, so I got a lot more done yesterday (I just can't be bothered to go and make a better screenshot right now):

![pixels.png](/images/pixels.png)

Basically we got most of the visual art done, meaning the mixer, the end-product display, and the money counter look ok. The only thing missing are the speech bubbles for the NPCs, though there are a few caveats:
- I did not do the ingredient selector, because I wan't to go a different direction with it
- Also did not do the base selector for the same reason
- The shop I just plain forgot

So depending on how the audio-stuff goes today, we may have time for feature work today, which is greatly needed, because I'm pretty sure I need the whole day tomorrow for content.

Btw, I ended up keeping the placeholder NPC silhouettes, because I could not find anything else that looks good.

The plan moving forward:
- Quickly do the NPC speech bubbles
- Add art to shop
- Add audio (I'm thinking no music, city noises in the background, gibber-speech on npc text - with maybe handling likes/dislikes, and audio feedback on UI interactions: vending machine sound on money, mixing, tip sound only if we get to add tipping, damage sound only if we add damage, purchase sounds on shop)
- Then back to coding and redo ingredient and base selection as a side panel
- Add customerdb to the sidepanel

---- This is the limit I think that is doable, so stretch goals ----
- Tooltips on every icon (will need to redo order box for this as well)


A note on the code quality: it's just gone at this point. Started Wednesday night. I snuck like/dislike dialogue handling before bed, but the gameplay loop wasn't intended for that, so I had to hack it. It would have been easy to do properly with half-a-days refactor, but who has that kind of time. Then Thursday happened, and now we are just hacking everything. Hopefully it's fine, we only want to add a few more features, so scalability and maintain issues won't have a chance surface...

