class SchedulePeriodDto {
  final String id;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime changeDate;

  const SchedulePeriodDto(
      {this.id, this.fromDate, this.toDate, this.changeDate});
}
