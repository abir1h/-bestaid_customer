class AppUrl {
  static const String liveBaseURL = "https://bestaid.com.bd/api";
  static const String pic_url1 = "https://bestaid.com.bd/";
  static const String pic_url2 = "https://bestaidtest1.s3.ap-southeast-1.amazonaws.com/";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/customer/login";
  static const String all_hospitals = baseURL + "customer/dhr/show/all/hospital";
  static const String reg = baseURL + "/customer/register";
  static const String otp = baseURL + "/customer/otp";
  static const String logout = baseURL + "/customer/logout";
  static const String change_pass = baseURL + "/customer/change-password";
  static const String specialdoctor = baseURL + "/show/all/doctor";
  static const String dhr = baseURL + "/customer/dhr/image/post";
  static const String psyco = baseURL + "/customer/psycho/make/appointment";
  static const String dhr_list = baseURL + "/customer/dhr/image/title/show";
  static const String image = baseURL + "/customer/dhr/image/show/";
  static const String rename = baseURL + "/customer/dhr/image/post/update/";
  static const String delete = baseURL + "/customer/dhr/image/post/delete/";

}
