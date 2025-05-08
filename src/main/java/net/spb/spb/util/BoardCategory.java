package net.spb.spb.util;

public enum BoardCategory {
    freeboard("자유게시판"),
    eduinfo("교육 정보 게시판"),
    uniinfo("대입 정보 게시판"),
    exactivity("대외활동 게시판"),
    reference("자료 게시판");
    private final String displayName;
    BoardCategory(String displayName) {
        this.displayName =  displayName;
    }
    public String getDisplayName() {
        return displayName;
    }
}
