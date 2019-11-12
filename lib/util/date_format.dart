class DateFormat {
  static String numberToString(int month) {
    switch (month) {
      case 1:
        return 'GENNAIO';
        break;
      case 2:
        return 'FEBBRAIO';
        break;
      case 3:
        return 'MARZO';
        break;
      case 4:
        return 'APRILE';
        break;
      case 5:
        return 'MAGGIO';
        break;
      case 6:
        return 'GIUGNO';
        break;
      case 7:
        return 'LUGLIO';
        break;
      case 8:
        return 'AGOSTO';
        break;
      case 9:
        return 'SETTEMBRE';
        break;
      case 10:
        return 'OTTOBRE';
        break;
      case 11:
        return 'NOVEMBRE';
        break;
      case 12:
        return 'DICEMBRE';

      default:
        return 'Non un mese valido';
    }
  }
}
