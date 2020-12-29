package hp.Final.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
//import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import hp.Final.dao.MemberDAO;
import hp.common.security.MD5Hash;
import hp.common.util.FileUtils;

@Service("memberService")
public class MemberServiceImpl implements MemberService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "fileUtils")
	private FileUtils fileUtils;

	@Resource(name = "memberDAO")
	private MemberDAO memberDAO;

	// 로그인
	@Override
	public String login(Map<String, Object> map, HttpSession session, Model model, HttpServletResponse response,
			RedirectAttributes rttr) throws Exception {
		// 암호 암호화
		map.put("PWD", MD5Hash.getEncMD5((String) map.get("PWD")));

		Map<String, Object> login = memberDAO.login(map);

		// 로그인 세션 생성
		if (login != null) {
			model.addAttribute("user", login);
			session.setAttribute("IDX", login.get("IDX"));
			session.setAttribute("ID", login.get("ID"));
			session.setAttribute("NAME", login.get("NAME"));
			session.setAttribute("ADDR", login.get("ADDR"));
			session.setAttribute("ID_IMG", login.get("ID_IMG"));

			if (login.get("ID").equals("admin")) {
				return "mainForm";
			}

			// 자동 로그인 체크되어 있으면
			if (map.get("autoLogin") != null) {
				Cookie autoLogin = new Cookie("autoLogin", session.getId());

				autoLogin.setPath("/");

				int amount = 60 * 60 * 24 * 7;
				autoLogin.setMaxAge(amount); // 단위는 (초)임으로 7일정도로 유효시간을 설정해 준다.
				// 쿠키를 적용해 준다.
				response.addCookie(autoLogin);

				String SESSIONK = session.getId();
				Date SESSIONL = new Date(System.currentTimeMillis() + (1000 * amount));

				map.put("ID", map.get("ID"));
				map.put("ID_SESSIONK", SESSIONK);
				map.put("ID_SESSIONL", SESSIONL);

				keepLogin(map);
			}
			model.addAttribute("body", "body");

			return "mainForm";
		} else { // 로그인 실패
			rttr.addFlashAttribute("msg", "비밀번호 또는 아이디를 다시 확인해주세요.");

			return "redirect:/member/loginForm";
		}
	};

	// 카카오 회원가입 및 로그인
	@Override
	public String kakaoLogin(Map<String, Object> map, HttpSession session, Model model, HttpServletResponse response,
			RedirectAttributes rttr) throws Exception {
		String ID = "";
		int check;

		// 암호 자체 생성
		map.put("PWD", MD5Hash.getEncMD5((String) map.get("ID")));

		if (map.get("ID") != null)
			ID = (String) map.get("ID");

		check = memberDAO.checkId(ID); // 카카오 회원인지 확인

		if (check != 1)
			memberDAO.insertMember(map); // 카카오 회원가입

		Map<String, Object> login = memberDAO.login(map); // 카카오 로그인

		// 로그인 세션 생성
		if (login != null) {
			model.addAttribute("user", login);
			session.setAttribute("IDX", login.get("IDX"));
			session.setAttribute("ID", login.get("ID"));
			session.setAttribute("NAME", login.get("NAME"));
			session.setAttribute("ADDR", login.get("ADDR"));
			session.setAttribute("ID_IMG", login.get("ID_IMG"));
		}
		model.addAttribute("body", "body");

		return "mainForm";
	}

	// 자동로그인
	@Override
	public void keepLogin(Map<String, Object> map) throws Exception {
		memberDAO.keepLogin(map);
	};

	// 유효시간이 넘지 않은 세션을 가지고 있는지 체크한다.
	@Override
	public Map<String, Object> checkUserWithSessionKey(String SESSIONKEY) throws Exception {

		return memberDAO.checkUserWithSessionKey(SESSIONKEY);
	}

	// 회원목록
	@Override
	public List<Map<String, Object>> selectMemberList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> memberList = memberDAO.selectMemberList(map);

		return memberList;
	};

	// 회원상세보기
	@Override
	public Map<String, Object> viewMember(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> viewMember = memberDAO.viewMember(map);
		resultMap.put("map", viewMember);

		return resultMap;
	};

	// 회원가입
	@Transactional
	@Override
	public void insertMember(Map<String, Object> map, RedirectAttributes rttr) throws Exception {
		// 유저 암호 암호화 처리
		map.put("PWD", MD5Hash.getEncMD5((String) map.get("PWD")));
	
		rttr.addFlashAttribute("authmsg", "가입시 사용할 이메일로 인증해주세요");
		rttr.addFlashAttribute("msg", "회원등록이 되었습니다. 로그인해주세요");
	
		memberDAO.insertMember(map); // 회원가입
	};

	// 유저 ID 중복 확인
	@Override
	public int checkId(Map<String, Object> map) throws Exception {
		String ID = "";

		if (map.get("ID") != null)
			ID = (String) map.get("ID");

		return memberDAO.checkId(ID);
	}

	// 이메일 인증확인
	@Override
	public void userAuth(Map<String, Object> map) throws Exception {
		memberDAO.userAuth(map);
	}

	// 비밀번호 변경
	@Override
	public void newPWD(Map<String, Object> map, RedirectAttributes rttr) throws Exception {
		map.put("PWD", MD5Hash.getEncMD5((String) map.get("PWD")));
		
		memberDAO.newPWD(map);
		
		rttr.addFlashAttribute("msg2", "비밀번호를 변경하였습니다. 다시 로그인해주세요.");
	}

	// 회원삭제
	public boolean deleteMember(Map<String, Object> map, HttpSession session) throws Exception {
		Map<String, Object> selectMember = memberDAO.viewMember(map);

		if (selectMember.get("PWD").equals(map.get("PWD"))) {
			session.invalidate();

			memberDAO.deleteMember(map);

			return true;
		}

		return false;
	}
}
