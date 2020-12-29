package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface MypageService {
	// MypageService
	// 마이페이지 내 정보 보기
	Map<String, Object> selectUserInfo(HttpSession session) throws Exception;

	// 마이페이지 내 정보 수정
	public void updateUserInfo(Map<String, Object> map) throws Exception;

	// 이미지 파일
	public void insertIMG(Map<String, Object> map, HttpSession session, MultipartHttpServletRequest multipartHttpServletRequest) throws Exception;

	// 이미지 삭제
	void deleteIMG(Map<String, Object> map, HttpSession session, HttpServletRequest request) throws Exception;

	// 마이페이지 회원 탈퇴
	public void deleteMember(Map<String, Object> map) throws Exception;

	// 관심병원리스트
	List<Map<String, Object>> selectFavList(Map<String, Object> map, HttpSession session) throws Exception;

	// 관심병원등록하기
	void insertFav(Map<String, Object> map, HttpSession session) throws Exception;

	// 포인트 적립하기
	void updatePoint(Map<String, Object> map, HttpSession session) throws Exception;

	// 관심병원삭제하기
	void delFavHp(Map<String, Object> map, HttpSession session) throws Exception;
}
