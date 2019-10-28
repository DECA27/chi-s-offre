class DateFormat {
  static String numberToString(int month) {
    switch (month) {
      case 1:
        return 'Gen';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'Mag';
        break;
      case 6:
        return 'Giu';
        break;
      case 7:
        return 'Lug';
        break;
      case 8:
        return 'Ago';
        break;
      case 9:
        return 'Set';
        break;
      case 10:
        return 'Ott';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dic';

      default:
        return 'Non un mese valido';
    }
  }
}
