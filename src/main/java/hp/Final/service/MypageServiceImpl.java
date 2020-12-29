package hp.Final.service;

import java.io.File;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import hp.Final.dao.MypageDAO;

@Service("mypageService")
public class MypageServiceImpl implements MypageService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "MypageDAO")
	private MypageDAO mypageDao;

	// 마이페이지 내 정보 보기
	@Override
	public Map<String, Object> selectUserInfo(HttpSession session) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ID", session.getAttribute("ID"));

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> detail = mypageDao.selectUserInfo(map);

		if (detail.get("GENDER") != null) {
			if (Integer.parseInt(detail.get("GENDER").toString()) % 2 == 1)
				detail.put("GENDER", "남성");
			else
				detail.put("GENDER", "여성");
		}

		// 비만도 계산
		if (detail.get("HEIGHT") != null && detail.get("WEIGHT") != null) {
			double height = ((BigDecimal) detail.get("HEIGHT")).doubleValue() / 100;
			int weight = ((BigDecimal) detail.get("WEIGHT")).intValue();
			double bmi = (float) weight / (height * height);

			detail.put("BMI", bmi);
		}
		resultMap.put("detail", detail);

		return resultMap;
	}

	// 마이페이지 내 정보 수정
	@Override
	public void updateUserInfo(Map<String, Object> map) throws Exception {
		mypageDao.updateUserInfo(map);
	};

	private static String IMGPath;

	// 이미지 파일
	@Override
	public void insertIMG(Map<String, Object> map, HttpSession session, MultipartHttpServletRequest multipartHttpServletRequest) throws Exception {
		Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
		MultipartFile multipartFile = null;

		while (iterator.hasNext()) {
			multipartFile = multipartHttpServletRequest.getFile(iterator.next());
		}

		IMGPath = multipartHttpServletRequest.getSession().getServletContext().getRealPath("img/UserImg/");
		System.out.println(IMGPath);
		String imgname = session.getAttribute("IDX") + ".png";

		map.put("IMG_NAME", imgname);
		map.put("IMG_SIZE", multipartFile.getSize());
		map.put("IDX", session.getAttribute("IDX"));

		multipartFile.transferTo(new File(IMGPath + imgname));

		mypageDao.insertIdIMG(map);
	}

	@Override
	public void deleteIMG(Map<String, Object> map, HttpSession session, HttpServletRequest request) throws Exception {
		IMGPath = request.getSession().getServletContext().getRealPath("img/UserImg/");
		String imgname = session.getAttribute("IDX") + ".png";

		File file = new File(IMGPath + imgname);
		file.delete();

		map.put("IDX", session.getAttribute("IDX"));

		mypageDao.deleteUserIMG(map);
	}

	// 마이페이지 회월탈퇴
	public void deleteMember(Map<String, Object> map) throws Exception {
		mypageDao.deleteMember(Integer.parseInt((String) map.get("IDX")));
	}

	// 포인트 적립하기
	@Override
	public void updatePoint(Map<String, Object> map, HttpSession session) throws Exception {
		map.put("ID", session.getAttribute("ID"));

		mypageDao.updatePoint(map);
	}

	// 관심병원 등록하기
	@Override
	public void insertFav(Map<String, Object> map, HttpSession session) throws Exception {
		map.put("ID", session.getAttribute("ID"));

		mypageDao.insertFav(map);
	}

	// 관심병원리스트
	@Override
	public List<Map<String, Object>> selectFavList(Map<String, Object> map, HttpSession session) throws Exception {
		map.put("ID", session.getAttribute("ID"));
		List<Map<String, Object>> templist = mypageDao.selectFavList(map);

		return templist;
	}

	// 관심병원 삭제하기
	@Override
	public void delFavHp(Map<String, Object> map, HttpSession session) throws Exception {
		map.put("ID", session.getAttribute("ID"));

		mypageDao.delFavHp(map);
	}
}
