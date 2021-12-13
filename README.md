# Dapproh: Private and Decentralized
[Demo Video](https://www.youtube.com/watch?v=BwFWRX57_tE)

[Hackathon Submission](https://devpost.com/software/dapproh)

## About

Dapproh is an encrypted completely decentralized social network built on IPFS, Filecoin, and SkynetDB. Dapproh functions as a mobile app built for iOS and Android.

In stark contrast to centralized social networks such as Instagram or Facebook, all content is encrypted. Nobody but followers can see posts, or even identify who is making a post.

## Problem Statement

Modern social networks have major issues, among them:

-   Privacy
    -   Social networks lack any sort of privacy. Even if an account is set to private, the contents of the account are still visible to the company and are vulnerable to being hacked.
    -   Social networks such as Facebook are also known to collect obscene amounts of data from user interaction.
-   Centralization
    -   Most social networks are extremely centralized. This means the main actor will abuse their position of power quite often with little repercussions.
    -   Centralized systems are also less resilient. The entirety of Facebook went down for a short while in 2021.
-   Censorship
    -   Social networks often will decide to appoint themselves as arbiters of the truth. Without much oversight, people in power can use this position to their advantage for their own political/financial gain.
-   Filter Bubbles
    -   Social networks are incentivize to keep their users on as long as possible. Social networks built algorithms with this in mind, which had the unintended side effect of showing content which predominantly reinforces user beliefs. In some cases this radicalizes users while generating additional revenue for the network.

## Dapproh's Solution

-   Privacy
    -   Because all data can only be decrypted by recipients with the key, intermediaries cannot steal or exploit its information.
    -   Because the application is decentralized, there is no interaction data to record. As the data does not exist, there is no threat for it to be hacked or exploited.
-   Centralization
    -   Dapproh does not have a centralized service to distribute content. IPFS and Skynet are decentralized, so the core functionality of Dapproh does not rely on a centralized service to function.
-   Censorship
    -   Because the system is decentralized, it is extremely censorship resistant. IPFS hosts can take down encrypted files, however the same file can be uploaded again but encrypted under a different key (all files are encrypted under different keys). This way, it is practically impossible to effectively censor Dapproh.
-   Filter Bubbles
    -   Feeds on Dapproh are chronological (most recent posts shown first). So while it is possible the user will only follow users with similar beliefs, there is no algorithm pushing a specific type of content for the user.

## How it works

-   Immutable data such as the encrypted images are stored on IPFS/Filecoin using Estuary.
-   Mutable data such as Profile information and feeds are stored on SkynetDB (also decentralized)
-   Users start by generating a mnemonic in app which is used to store and access data in Skynet.
-   With that mnemonic, the data in app is encrypted and backed up to Skynet.
-   An encryption key is then securely generated and used to encrypt that users public feed. This is where information about posts/the users profile is stored.
    -   Another encryption key is then generated and used to encrypt the Public Feed key. The encrypted public feed key is then stored in the Friend File.
    -   Whenever a user wants to follow another feed. They first have to ask for the Friend Code. The friend code contains the location of the user on Skynet as well as the means to decrypt the Friend File. That users client then retrieves the Friend File with the friend code and can then access the users public feed. It is done this way so the friend codes can be reset without needing to distribute a new key all of the existing followers.
-   When a user makes a post, a new encryption key is generated. That key is then used to encrypt the image. The encrypted image is then uploaded to Estuary (IPFS/Filecoin). Once the CID is returned, the posts information is then added to the public feed and uploaded to Skynet (encrypted of course :) )
-   When a user wants view their feed, the Dapproh client retrieves and decrypts the public feeds of all of the users they are following. When the feeds come back, the images are then downloaded from IPFS, decrypted, and rendered on the feed. The most recent posts are displayed first.

