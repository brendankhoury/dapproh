# Schema for the skynet users

## Public user:

### Feed (encrypted with follower key)

-   Profile Picture:
    -   [IPFS link]
    -   Encryption key
-   Feed:
    -   Posts[]
        -   Date Posted
        -   Post description/title
        -   Post image [IPFS link]
        -   Post encryption key
-   Name

### Friend File (encrypted with key sent in friend code)

-   Follower key
-   Feed location

## Private user: (encrypted with key generated by mnemonic)

-   Following:
    -   Users[]
        -   Skynet public key
        -   Feed location
        -   Nickname (optional)
        -   Follower key
-   User Posts (Posts are stored here in case the user wants to hide a post in the public profile)
    -   Posts[]
        -   Date Posted
        -   Post description/title
        -   Post image [IPFS link]
        -   Post encryption key
