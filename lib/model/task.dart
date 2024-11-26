
class Task {
  int? _id;
  String _title;
  String? _description;
  String _creationDate = DateTime.now().toString();
  String? _finishDate;
  int _isDone = 0;
  int _isDisable = 0;

  Task(this._title, this._description);

  String get id => _id.toString();

  String get description => _description!;

  String get title => _title;

  String get creationDate => _creationDate;

  String get finishDate => _finishDate!;

  int get isDone => _isDone;

  int get isDisable => _isDisable;

  void setTitle(String title) {
    if (title.length <= 50) {
      _title = title;
    } else {
      throw Exception("Title must be less than 50 characters");
    }
  }

  void setDescription(String description) {
    if (description.length <= 255) {
      _description = description;
    } else {
      throw Exception("Description must be less than 255 characters");
    }
  }

  void setCreationDate(String creationDate) {
    _creationDate = creationDate;
  }

  void setFinishDate(String finishDate) {
    _finishDate = finishDate;
  }

  void setIsDone(int isDone) {
    if (isDone == 0 || isDone == 1) {
      _isDone = isDone;
    } else {
      throw Exception("isDone must be 0 or 1");
    }
  }

  void setIsDisable(int isDisable) {
    if (isDisable == 0 || isDisable == 1) {
      _isDisable = isDisable;
    } else {
      throw Exception("isDisable must be 0 or 1");
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['creationDate'] = _creationDate;
    map['finishDate'] = _finishDate;
    map['isDone'] = _isDone;
    map['isDisable'] = _isDisable;

    return map;
  }

  Task.fromMap(Map<String, dynamic> map)
      : _id = map['id'],
        _title = map['title'],
        _description = map['description'],
        _creationDate = map['creationDate'],
        _finishDate = map['finishDate'],
        _isDone = map['isDone'],
        _isDisable = map['isDisable'];
}
