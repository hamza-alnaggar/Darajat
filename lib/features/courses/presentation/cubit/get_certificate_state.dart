

abstract class GetCertificateState {}

class GetCertificateInitial extends GetCertificateState {}

class GetCertificateLoading extends GetCertificateState {}

class GetCertificateSuccess extends GetCertificateState {
  final String link;
  GetCertificateSuccess({required this.link});
}
class GetCertificateFailure extends GetCertificateState {
  final String errMessage;

  GetCertificateFailure({required this.errMessage});
}