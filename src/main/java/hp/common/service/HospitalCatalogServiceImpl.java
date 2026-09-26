package hp.common.service;
import java.util.*;import javax.annotation.Resource;import javax.servlet.http.HttpSession;
import org.mybatis.spring.SqlSessionTemplate;import org.springframework.stereotype.Controller;import org.springframework.ui.Model;import org.springframework.web.bind.annotation.*;import org.springframework.transaction.annotation.Transactional;import hp.common.security.SessionIdentity;
/** Newly implemented catalog maintenance using the original HOSPITAL columns and Oracle datasource. */
@org.springframework.stereotype.Service("hospitalCatalogService")
public class HospitalCatalogServiceImpl implements HospitalCatalogService {
 @Resource(name="sqlSessionTemplate") private SqlSessionTemplate sql;
 public List<Map<String,Object>> list(HttpSession session){SessionIdentity.admin(session);return sql.selectList("catalog.list");}
 @Transactional(rollbackFor=Exception.class)
 public String save(Map<String,Object> p,HttpSession session){SessionIdentity.admin(session);for(String k:new String[]{"HOSP","MAJOR","ADDR","TEL"})if(p.get(k)==null||String.valueOf(p.get(k)).trim().isEmpty()||String.valueOf(p.get(k)).length()>500)throw new IllegalArgumentException("Invalid hospital "+k);
  for(String k:new String[]{"HOSP","MAJOR","ADDR","TEL"})p.put(k,org.springframework.web.util.HtmlUtils.htmlEscape(String.valueOf(p.get(k))));
  for(String k:new String[]{"ONHOUR","OFFHOUR","MEAL_TIME"})if(!String.valueOf(p.get(k)).matches("([01][0-9]|2[0-3])[0-5][0-9]"))throw new IllegalArgumentException("Invalid operating hours");
  int interval=Integer.parseInt(String.valueOf(p.get("INTERVALL")));if(interval<5||interval>240)throw new IllegalArgumentException("Invalid interval");if(Integer.parseInt(String.valueOf(p.get("OFFHOUR")))<=Integer.parseInt(String.valueOf(p.get("ONHOUR"))))throw new IllegalArgumentException("Invalid operating hours");
  if(!Arrays.asList("Y","N").contains(p.get("REG_CHK")))throw new IllegalArgumentException("Invalid registration status");
  if(p.get("H_IDX")==null||String.valueOf(p.get("H_IDX")).isEmpty())sql.insert("catalog.insert",p);else{sql.selectOne("reserv.lockHospital",p);if(sql.update("catalog.update",p)!=1)throw new IllegalArgumentException("Hospital not found");}return "redirect:/admin/catalog";
 }
 @Transactional(rollbackFor=Exception.class)
 public String remove(Map<String,Object> p,HttpSession session){SessionIdentity.admin(session);sql.selectOne("reserv.lockHospital",p);if(((Number)sql.selectOne("catalog.activeReservations",p)).intValue()!=0)throw new IllegalStateException("Upcoming appointments must be resolved");if(sql.update("catalog.remove",p)!=1)throw new IllegalArgumentException("Hospital not found");sql.delete("catalog.removeFavorites",p);return "redirect:/admin/catalog";}
}
