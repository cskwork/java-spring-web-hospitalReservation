package hp.Final.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import hp.common.dao.AbstractDAO;

@SuppressWarnings("unchecked")
@Repository("MypageDAO")
public class MypageDAO extends AbstractDAO {
	// 마이페이지 내 정보 보기
	public Map<String, Object> selectUserInfo(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) selectOne("mypage.selectUserInfo", map);
	}

	// 마이페이지 내 정보 보기
	public void updateUserInfo(Map<String, Object> map) throws Exception {
		update("mypage.updateUserInfo", map);
	};

	// 이미지 삽입
	public void insertIdIMG(Map<String, Object> map) throws Exception {
		update("mypage.updateUserIMG", map);
	}

	// 이미지 삭제
	public void deleteUserIMG(Map<String, Object> map) throws Exception {
		update("mypage.deleteUserIMG", map);
	}

	// 마이페이지 회월 탈퇴
	public void deleteMember(int IDX) throws Exception {
		delete("member.deleteMember", IDX);
	}

	// 포인트 적립하기
	public void updatePoint(Map<String, Object> map) throws Exception {
		update("mypage.updatePoint", map);
	}

	// 포인트 차감하기
	public void updatePoint2(Map<String, Object> map) throws Exception {
		update("mypage.updatePoint2", map);
	}

	// 포인트 돌려주기
	public void returnPoint(Map<String, Object> map) throws Exception {
		update("mypage.returnPoint", map);
	}

	// 관심병원리스트
	public List<Map<String, Object>> selectFavList(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) selectList("mypage.selectFavList", map);
	}

	// 관심병원 등록
	public void insertFav(Map<String, Object> map) throws Exception {
		insert("mypage.insertFav", map);
	}

	// 관심병원 삭제하기
	public void delFavHp(Map<String, Object> map) throws Exception {
		delete("mypage.delFavHp", map);
	}
}
