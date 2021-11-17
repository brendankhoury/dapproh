class Post {
  DateTime datePosted;
  String description;
  String postLink; // IPFS access data, for now an estuary link.
  String postKey;
  String posterPubKey;
  String posterName;
  Post(this.datePosted, this.description, this.postLink, this.postKey, this.posterPubKey, this.posterName);
}
