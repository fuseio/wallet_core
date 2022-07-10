const String getCollectiblesByOwnerQuery = r'''
  query getCollectiblesByOwner($owner: String!) {
      collectibles(where: {owner: $owner}) {
        id
        name
        imageURL
        description
        collectionName
        collectionSymbol
        collectionAddress
      }
  }
''';
