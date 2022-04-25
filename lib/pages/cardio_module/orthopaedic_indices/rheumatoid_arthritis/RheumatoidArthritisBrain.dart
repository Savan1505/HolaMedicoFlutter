class RheumatoidArthritisBrain {
  int result = 0;
  String description = "";

  RheumatoidArthritisBrain(this.result);

  calculate() {
    if (result >= 6) {
      description = "Definite RA";
    } else {
      description = "Not classifiable as having RA by ACR/EULAR Criteria";
    }
  }

  getDescription() {
    return description;
  }
}
