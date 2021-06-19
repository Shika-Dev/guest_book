class Guest {
  int _id;
  String _name;
  String _namaIstri;
  String _bin;
  String _alm1;
  String _alm2;
  String _alamat;
  String _telp;
  String _kali;
  String _besar;
  String _tanggal;

  Guest(this._name, this._namaIstri, this._bin, this._alm1, this._alm2, this._alamat, this._telp, this._kali, this._besar, this._tanggal);


  Guest.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._namaIstri = map['namaIstri'];
    this._bin = map['bin'];
    this._alm1 = map['alm1'];
    this._alm2 = map['alm2'];
    this._alamat = map['alamat'];
    this._telp = map['telp'];
    this._kali = map['kali'];
    this._besar = map['besar'];
    this._tanggal = map['tanggal'];
  }

  int get id => _id;
  String get name => _name;
  String get namaIstri => _namaIstri;
  String get bin => _bin;
  String get alm1 => _alm1;
  String get alm2 => _alm2;
  String get alamat => _alamat;
  String get telp => _telp;
  String get kali => _kali;
  String get besar => _besar;
  String get tanggal => _tanggal;

  // setter
  set name(String value) {
    _name = value;
  }

  set namaIstri(String value) {
    _namaIstri = value;
  }

  set bin(String value) {
    _bin = value;
  }

  set alm1(String value) {
    _alm1 = value;
  }

  set alm2(String value) {
    _alm2 = value;
  }

  set alamat(String value) {
    _alamat = value;
  }

  set telp(String value) {
    _telp = value;
  }

  set kali(String value) {
    _kali = value;
  }

  set besar(String value) {
    _besar = value;
  }

  set tanggal(String value) {
    _tanggal = value;
  }


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['namaIstri'] = namaIstri;
    map['bin'] = bin;
    map['alm1'] = alm1;
    map['alm2'] = alm2;
    map['alamat'] = alamat;
    map['telp'] = telp;
    map['kali'] = kali;
    map['besar'] = besar;
    map['tanggal'] = tanggal;

    return map;
  }

}