String hexZeroPad(String value, num length) {
  while (value.length < 2 * length + 2) {
    value = '0x0' + value.substring(2);
  }
  return value;
}

String hexlify(BigInt dec) {
  return '0x0' + dec.toRadixString(16);
}
