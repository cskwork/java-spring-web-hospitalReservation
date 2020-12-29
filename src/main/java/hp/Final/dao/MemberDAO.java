package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@SuppressWarnings("unchecked")
@Repository("memberDAO")
public class MemberDAO extends AbstractDAO {

	// 01 로그인
	// 로그인
	public Map<String, Object> login(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) selectOne("member.login", map);
	};

	// 로그인 유지
	public void keepLogin(Map<String, Object> map) throws Exception {
		update("member.keepLogin", map);
	};

	// 세션 있는지 확인, 자동 로그인
	public Map<String, Object> checkUserWithSessionKey(String ID_SESSIONK) throws Exception {
		return (Map<String, Object>) selectOne("member.checkUserWithSessionKey", ID_SESSIONK);
	}

	// 02 회원가입+목록
	// 회원목록
	public List<Map<String, Object>> selectMemberList(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectPagingList("member.selectMemberList", map);
	};

	// 회원정보 상세
	public Map<String, Object> viewMember(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) selectOne("member.viewMember", map);
	};

	// 회원가입
	public void insertMember(Map<String, Object> map) throws Exception {
		insert("member.insertMember", map);
	};

	// 회원가입시 ID 중복 확인
	public int checkId(String ID) {
		return (int) selectOne("member.checkId", ID);
	};

	// 비밀번호 변경
	public void newPWD(Map<String, Object> map) throws Exception {
		update("member.newPWD", map);
	}

	// 회원탈퇴
	public List<Map<String, Object>> deleteMember(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) delete("member.deleteMember", map);
	}

	// 이메일 인증번호 생성
	@SuppressWarnings("null")
	public void createAuthKey(String user_email, String user_authCode) throws Exception {
		Map<String, Object> userInfo = null;
		userInfo.put("EMAIL", user_email);
		userInfo.put("AUTHCODE", user_authCode);

		selectOne("member.createAuthKey", userInfo);
	}

	public void userAuth(Map<String, Object> map) {
		update("member.userAuth", map);
	}

	// map object 안에 boolean 값 1||null이 있다.
	public Map<String, Object> getUserId(Map<String, Object> map) {
		return (Map<String, Object>) selectList("member.getUserId", map);
	}
}
