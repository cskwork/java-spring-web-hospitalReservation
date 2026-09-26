package hp.common.service;
import java.util.*;import java.nio.file.*;import java.nio.charset.StandardCharsets;import java.security.*;
import javax.annotation.Resource;import javax.servlet.http.*;
import org.springframework.stereotype.Controller;import org.springframework.web.bind.annotation.*;import org.springframework.transaction.annotation.Transactional;import org.mybatis.spring.SqlSessionTemplate;
import hp.common.security.PasswordHash;
/** New native reset contract. Tokens persist in Oracle; local outbox only when explicitly configured. */
@org.springframework.stereotype.Service("passwordResetService")
public class PasswordResetServiceImpl implements PasswordResetService {
 @Resource(name="sqlSessionTemplate") private SqlSessionTemplate sql;
 private String digest(String t)throws Exception {byte[] b=MessageDigest.getInstance("SHA-256").digest(t.getBytes(StandardCharsets.UTF_8));return Base64.getEncoder().encodeToString(b);}
 @Transactional(rollbackFor=Exception.class)
 public Map<String,Object> request(String id)throws Exception {
  String directory=System.getenv("DRHER_LOCAL_OUTBOX");if(directory==null||directory.trim().isEmpty())throw new IllegalStateException("Mail provider not configured");
  Map<String,Object> p=new HashMap<String,Object>();p.put("ID",id);Map<String,Object> member=sql.selectOne("member.login",p);
  if(member!=null){byte[] random=new byte[32];new SecureRandom().nextBytes(random);String token=Base64.getUrlEncoder().withoutPadding().encodeToString(random);p.put("TOKEN_HASH",digest(token));sql.insert("secure.insertReset",p);Path dir=Paths.get(directory).toAbsolutePath().normalize();Files.createDirectories(dir);Files.write(dir.resolve(UUID.randomUUID().toString()+".txt"),("LOCAL SYNTHETIC OUTBOX\nAccount: "+id+"\nToken: "+token+"\nExpires in 15 minutes\n").getBytes(StandardCharsets.UTF_8),StandardOpenOption.CREATE_NEW);}
  return Collections.<String,Object>singletonMap("ok",true);
 }
 @Transactional(rollbackFor=Exception.class)
 public Map<String,Object> confirm(String token,String password)throws Exception {
  Map<String,Object> p=new HashMap<String,Object>();p.put("TOKEN_HASH",digest(token));Map<String,Object> reset=sql.selectOne("secure.lockReset",p);if(reset==null)throw new SecurityException("Expired or used reset token");p.put("ID",reset.get("ID"));p.put("PWD",PasswordHash.hash(password));if(sql.update("member.newPWD",p)!=1)throw new IllegalStateException("Password update failed");if(sql.update("secure.consumeReset",p)!=1)throw new IllegalStateException("Reset already consumed");return Collections.<String,Object>singletonMap("ok",true);
 }
}
