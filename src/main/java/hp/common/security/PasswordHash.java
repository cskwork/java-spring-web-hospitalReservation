package hp.common.security;
import java.security.*;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.util.Base64;
/** New password format. Legacy MD5 is deliberately not accepted: reset before migration. */
public final class PasswordHash {
 private static final int ITERATIONS=600000;
 public static String hash(String password) throws Exception {
  if(password==null||password.length()<10||password.length()>128)throw new IllegalArgumentException("Password must contain 10 to 128 characters");
  byte[] salt=new byte[16];new SecureRandom().nextBytes(salt);
  return "pbkdf2$"+ITERATIONS+"$"+Base64.getEncoder().encodeToString(salt)+"$"+Base64.getEncoder().encodeToString(derive(password,salt,ITERATIONS));
 }
 public static boolean verify(String password,String encoded) throws Exception {
  if(password==null||encoded==null||!encoded.startsWith("pbkdf2$"))return false;
  try{String[] a=encoded.split("\\$");int n=Integer.parseInt(a[1]);if(n<600000||n>1000000)return false;return MessageDigest.isEqual(Base64.getDecoder().decode(a[3]),derive(password,Base64.getDecoder().decode(a[2]),n));}catch(IllegalArgumentException e){return false;}
 }
 private static byte[] derive(String p,byte[] salt,int n)throws Exception{return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(new PBEKeySpec(p.toCharArray(),salt,n,256)).getEncoded();}
 private PasswordHash(){}
}
