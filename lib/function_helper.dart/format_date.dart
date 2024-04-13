String formatTimestamp(int timestamp) {
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  int timeDifference = currentTime - timestamp;

  // Tính toán số lượng ngày chênh lệch
  int daysDifference = (timeDifference / (1000 * 60 * 60 * 24)).floor();

  if (daysDifference >= 7) {
    // Nếu hơn một tuần, hiển thị ngày tháng dạng dd-mm-yy
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String day = date.day < 10 ? '0${date.day}' : '${date.day}';
    String month =
        (date.month + 1) < 10 ? '0${date.month + 1}' : '${date.month + 1}';
    String year = date.year.toString().substring(2);

    String formattedDate = '$day/$month/$year';
    return formattedDate;
  } else if (daysDifference > 0) {
    // Hiển thị x ngày trước
    return '$daysDifference ngày trước';
  } else {
    // Tính toán số lượng giờ chênh lệch
    int hoursDifference = (timeDifference / (1000 * 60 * 60)).floor();

    if (hoursDifference > 0) {
      // Hiển thị x tiếng trước
      return '$hoursDifference tiếng trước';
    } else {
      // Tính toán số lượng phút chênh lệch
      int minutesDifference = (timeDifference / (1000 * 60)).floor();

      if (minutesDifference > 0) {
        // Hiển thị x phút trước
        return '$minutesDifference phút trước';
      } else {
        // Hiển thị "mới đây"
        return 'mới đây';
      }
    }
  }
}
