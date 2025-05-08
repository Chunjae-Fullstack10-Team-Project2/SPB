package net.spb.spb.util;

public class MemberUtil {
    public String getMemberState (String memberState) {
        switch(memberState) {
            case "1": return "활성";
            case "2": return "정지";
            case "3": return "비밀번호 변경 필요";
            case "4": return "비밀번호 5회 틀림";
            case "5": return "휴면";
            case "6": return "탈퇴";
            default: return "";
        }
    }
    public String getMemberGrade (String memberGrade) {
        switch(memberGrade) {
            case "0": return "관리자";
            case "1": return "초1";
            case "2": return "초2";
            case "3": return "초3";
            case "4": return "초4";
            case "5": return "초5";
            case "6": return "초6";
            case "7": return "중1";
            case "8": return "중2";
            case "9": return "중3";
            case "10": return "고1";
            case "11": return "고2";
            case "12": return "고3";
            case "13": return "교사";
            case "14": return "기타";
            default: return "";
        }
    }

}
