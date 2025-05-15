# KLONDIKE SOLITAIRE

CMPM 121 Assignment 2
Name: Maddison Lobo

### Programming Patterns

State patterns
    I used state patterns to track card states between idle, mouse over, and grabbed. This made it easy
    to make the cards or the grabber react differently depending on the state of the card. It also differentiates
    how the cards react different when they are simply hovered over verses actaully grabbed. 

Observer patterns
    I used these patterns in order to track mouse movement and which cards had the mouse over it at what time. 
    It helped by allowing each card to act and process the input detection independently. This also allows for features
    like the shadow and any other features I may add. 

Sequencing patterns
    I used these to iterate over the differnt tables of cards I have whether its loading sprites, placing cards, shuffling
    them, or drawing from the stack. This made it easy to get all the cards in a couple lines as well as make the effect or
    action uniform. 


### Code Feedback

-Kayla Nguyen -- Partner for both discussion section reviews
    Comments: Break up longer if statements and seperate code into more files. I added a new file for a lot of the game start
    and game upkeep mechanics as opposed to leaving them in main. I made the functionality of my if statements more clear and 
    condensed to make readability better. 

Mick Lim
    Comments: Change things so the cards dont go off the screen. Fix win case so that player can place last card consistently. 
    I made the game screen bigger to adjust for the cards going off screen. I had to chance my win condition to check if the card
    state was idle to make sure the counter counted properly and the player was consistently able to place the final card. 

Alyssa Orozco
    Comments: The state indicators made it hard to se some of the cards. Remove the clickable card once there are no more cards
    to draw. I cleaned up my debug print statements as well as the card state indicator to make the game cleaner. I added
    I condition that would remove the top card on the draw pile once the pile is empty. 


### Postmortem

    I broke up my code into more files for this project which made things feel a lot more clear. I didn't get the chance to
    fix my sprites to make them from one sheet whcih is an optimization that I wanted to make; however, I did rename my sprites
    to make the rank and suit assignment more clear. My main file is a lot shorter which I believe is a big imporvement. I think
    there is still a bit too many parts of longer code that could be simplified or refactored to be more intuitive. 


### Assets

Sprites: https://opengameart.org/content/playing-cards-pack
I didn’t make any of the assets in this project.

I used the base solitare code we got from lecture as a base and built my code up from it!