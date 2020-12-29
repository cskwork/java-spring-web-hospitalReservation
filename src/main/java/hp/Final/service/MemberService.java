package hp.Final.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

public interface MemberService {
	// 로그인
	public String login(Map<String, Object> map, HttpSession session, Model model, HttpServletResponse response, RedirectAttributes rttr) throws Exception;

	// 자동 로그인
	public void keepLogin(Map<String, Object> map) throws Exception;

	// 유효시간이 넘지 않은 세션을 가지고 있는지 체크한다.
	public Map<String, Object> checkUserWithSessionKey(String SESSIONKEY) throws Exception;

	// 회원목록
	public List<Map<String, Object>> selectMemberList(Map<String, Object> map) throws Exception;

	// 회원상세보기
	public Map<String, Object> viewMember(Map<String, Object> map) throws Exception;
	
	// 회원가입
	public void insertMember(Map<String, Object> map, RedirectAttributes rttr) throws Exception;

	// 회원가입시 중복 확인
	public int checkId(Map<String, Object> map) throws Exception;
	
	// 회원가입시 이메일 인증
	public void userAuth(Map<String, Object> map) throws Exception;
	
	// 비밀번호 변경
	public void newPWD(Map<String, Object> map, RedirectAttributes rttr) throws Exception;

	// 회원삭제
	public boolean deleteMember(Map<String, Object> map, HttpSession session) throws Exception;
	
	//카카오 로그인
	public String kakaoLogin(Map<String, Object> map, HttpSession session, Model model, HttpServletResponse response, RedirectAttributes rttr) throws Exception;	
} 
