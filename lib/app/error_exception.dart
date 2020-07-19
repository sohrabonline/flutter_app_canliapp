class Hatalar{

   String goster(String kod){

     switch(kod){
       case "ERROR_EMAIL_ALREADY_IN_USE":
         return "Bu email artıq sistemdə qeyd olunub";
         case "ERROR_USER_NOT_FOUND":
         return "İstifadəçi tapılmadı!";
       default:
         return "İnternet bağlantısı zamanı problem yarandı";

     }

   }


}