# Dapproh: Private and Decentralized

## About

Dapproh is an encrypted completely decentralized social network. Built on IPFS, Filecoin, and SkynetDB. Dapproh functions as a mobile app built for iOS and Android.

In stark contrast to centralized social networks such as Instagram or Facebook, nobody but followers can see posts, or even identify who is making a post.

## Problem Statement

Modern social networks have major issues, among them:

-   ### Privacy
    -   Social networks lack any sort of privacy. Even if an account is set to private, the contents of the account are still visible to the company and are vulnerable to being hacked.
    -   Social networks such as Facebook are also known to collect obscene amounts of data from user interaction.
-   ### Centralization
    -   Most social networks are extremely centralized. This means the main actor will abuse their position of power quite often with little repercussions.
    -   Centralized systems are also less resilient. The entirety of Facebook went down for a short while in 2021.
-   ### Censorship
    -   Social networks often will decide to appoint themselves as arbiters of the truth. Without much oversight, people in power can use this position to their advantage for their own political/financial gain.
-   ### Filter Bubbles
    -   Social networks are incentivize to keep their users on as long as possible. Social networks built algorithms with this in mind, which had the unintended side effect of showing content which predominantly reinforces user beliefs. In some cases this radicalizes users while generating additional revenue for the network.

## Dapproh's Solution

-   ### Privacy
    -   Because all data can only be decrypted by recipients with the key, intermediaries cannot steal or exploit its information.
    -   Because the application is decentralized, there is no interaction data to record. As the data does not exist, there is no threat for it to be hacked or exploited.
-   ### Centralization
    -   Dapproh does not have a centralized service to distribute content. IPFS and SkyNet are decentralized, so the core functionality of Dapproh does not rely on a centralized service to function.
-   ### Censorship
    -   Because the system is decentralized, it is extremely censorship resistant. IPFS hosts can take down encrypted files, however the same file can be uploaded again but encrypted under a different key (all files are encrypted under different keys). This way, it is practically impossible to effectively censor Dapproh.
-   ### Filter Bubbles
    -   Feeds on Dapproh are chronological (most recent posts shown first). So while it is possible the user will only follow users with similar beliefs, there is no algorithm pushing a specific type of content for the user.

## How it works

-   Dapproh is an app built in flutter and designed for both iOS and Android.
-   Users start by generating a mnemonic in app which is used to store and access data in Skynet.
-   With that mnemonic, two separate SkyUsers in skynet are generated.
    -   The first user is the private SkyUser. It is used to store the keys and locations of the feeds they are following.
    -   The second user is the public SkyUser, this is where the feed is stored. Whenever the user makes a post, the feed is updated and only the followers can know the location of the file, and access its encrypted content. Profile information is also stored here (such as the profile picture location).
    -   All data uploaded is encrypted, however, the public SkyUser data is able to be decrypted by followers only.
-   When a user makes a post, their file is uploaded to Estuary (IPFS/Filecoin). The "access code" is stored in the public user along with the encryption details. Later when their followers want to view the post, they are able to access the image along with any image metadata. The followers will be notified of the posts existence by viewing he posters feed file in Skynet.
-   Friend codes are ways that a user can follow another user. A friend code contains information to access the friendFile (location and encryption key). A friendFile contains a location and encryption key to the public users feed.
    -   When another user successfully follows using the friend code the friendFile can be reset. This allows other users to continue following uninterrupted while maintaining a piece of mind that the friend codes sent are not longer valid.
