class UserRegisterValidation{
  final String userName;
  final String email;
  final String userAddress;

  UserRegisterValidation({required this.userName, required this.email, required this.userAddress} );

  void validation(){
    if(userName.isNotEmpty){

      if(email.isNotEmpty){

        if(userAddress.isNotEmpty){

        }

      }
      else{

      }
    }
    else{

    }
  }


}