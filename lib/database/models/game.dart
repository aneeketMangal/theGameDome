class Game {
  int _id;
  int _score;
  int _gameId;
  int _difficulty;
  String _username;
  int _charPos;
  Game.basic();
  Game(this._score, this._gameId, this._difficulty);
  Game.withId(this._id, this._score, this._gameId, this._difficulty);

  int get id => _id;
  int get gameId => _gameId;
  int get score => _score;
  int get difficulty => _difficulty;
  int get charPos => _charPos;
  String get username => _username;

  set gameId(int newgameId) {
    this._gameId = newgameId;
  }

  set score(int newScore) {
    this._score = newScore;
  }

  set difficulty(int newDifficulty) {
    this._difficulty = newDifficulty;
  }

  set charPos(int newCharPos) {
    this._charPos = newCharPos;
  }

  set username(String newUsername) {
    this._username = newUsername;
  }

  // Convert a Game object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['score'] = _score;
    map['difficulty'] = _difficulty;
    map['gameId'] = _gameId;
    map['charPos'] = _charPos;
    map['username'] = _username;
    return map;
  }

  // Extract a Game object from a Map object
  Game.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._score = map['score'];
    this._difficulty = map['difficulty'];
    this._gameId = map['gameId'];
    this._charPos = map['charPos'];
    this._username = map['username'];
  }
}
