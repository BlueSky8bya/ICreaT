enum WeigthDeviceGender { male, female }

extension WeigthDeviceGenderExt on WeigthDeviceGender {
  bool get isMale => this == WeigthDeviceGender.male;
  bool get isFemale => this == WeigthDeviceGender.female;

  int get code {
    switch (this) {
      case WeigthDeviceGender.male:
        return 0;
      case WeigthDeviceGender.female:
        return 1;
    }
  }
}
