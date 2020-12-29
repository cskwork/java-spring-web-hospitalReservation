package hp.common.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import hp.common.dao.CommonDAO;

@Service("commonService")
public class CommonServiceImpl implements CommonService {
   Logger log = Logger.getLogger(this.getClass());

   @Resource(name = "commonDAO")
   private CommonDAO commonDAO;

   @Override
   public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception {
      return commonDAO.selectFileInfo(map);
   }
   
   @Override
   public List<Map<String, Object>> selectCount(Map<String, Object> map) throws Exception {
      List<Map<String, Object>> tempList = new ArrayList<>();
      
      Map<String, Object> tempMap1 = commonDAO.selectHPCount(map);
      Map<String, Object> tempMap2 = commonDAO.selectRATE1Count(map);
      Map<String, Object> tempMap3 = commonDAO.selectRATE2Count(map);
      Map<String, Object> tempMap4 = commonDAO.selectMEMBERCount(map);
      
      tempList.add(tempMap1);
      tempList.add(tempMap2);
      tempList.add(tempMap3);
      tempList.add(tempMap4);
      
      return tempList;
   }
   
   @Override
   public List<Map<String, Object>> selectReview(Map<String, Object> map) throws Exception {
      return commonDAO.selectReview(map);
   }
}