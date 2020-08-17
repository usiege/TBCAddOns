local ELKBUFFBARS, private = ...

local L = LibStub("AceLocale-3.0"):NewLocale(ELKBUFFBARS, "koKR")
if not L then return end

L["TOOLTIP_BARGROUP"] = "바 그룹"
L["TOOLTIP_TYPE"] = "유형"
L["TOOLTIP_CLICK_CONFIGMODE"] = "클릭하면 바 설정을 불러옵니다."
L["TOOLTIP_RIGHTCLICK_OPTIONS"] = "오른쪽 클릭하면 설정창을 엽니다."
L["TOOLTIP_CASTER"] = "시전자:"

L["OPTIONS_OVERRIDES_NAME"] = "오버라이드 설정"
L["OPTIONS_OVERRIDES_DESC"] = "알고 있는 버프의 유형과 이름을 변경합니다."
L["OPTIONS_OVERRIDES_NAME_NAME"] = "이름 표시"
L["OPTIONS_OVERRIDES_NAME_DESC"] = "이름 표시를 설정합니다."
L["OPTIONS_OVERRIDES_TYPE_NAME"] = "새 유형"
L["OPTIONS_OVERRIDES_TYPE_DESC"] = "새 유형을 설정합니다."
L["OPTIONS_OVERRIDES_TYPE_OPTION_DEFAULT"] = "기본값"
L["OPTIONS_BARGROUPS_NAME"] = "그룹 설정"
L["OPTIONS_BARGROUPS_DESC"] = "바 그룹의 설정을 변경합니다."
L["OPTIONS_NEWGROUP_NAME"] = "새 그룹"
L["OPTIONS_NEWGROUP_DESC"] = "새로운 바 그룹을 생성합니다."
L["OPTIONS_GROUPSPACING_NAME"] = "그룹 간격"
L["OPTIONS_GROUPSPACING_DESC"] = "바 그룹에 바 사이의 공간의 간격을 설정합니다."
L["OPTIONS_HIDEBLIZZARDBUFFS_NAME"] = "블리자드 버프 프레임 숨김"
L["OPTIONS_HIDEBLIZZARDBUFFS_DESC"] = "블리자드 버프 프레임의 표시/숨김을 전환합니다."
L["OPTIONS_HIDEBLIZZARDTENCH_NAME"] = "블리자드 무기버프 프레임 숨김"
L["OPTIONS_HIDEBLIZZARDTENCH_DESC"] = "블리자드 무기버프 프레임의 표시/숨김을 전환합니다."
L["OPTIONS_HIDEBLIZZARDTRACKING_NAME"] = "미니맵 추적 프레임 숨김"
L["OPTIONS_HIDEBLIZZARDTRACKING_DESC"] = "미니맵 추적 프레임의 표시/숨김을 전환합니다."
L["OPTIONS_MINIMAP_NAME"] = "미니맵 버튼 표시"
L["OPTIONS_MINIMAP_DESC"] = "EBB의 미니맵 아이콘을 표시합니다."
L["OPTIONS_GROUP_NAME"] = "그룹 %d"
L["OPTIONS_GROUP_DESC"] = "그룹 %d|1을;를; 설정합니다."
L["OPTIONS_GROUP_CONFIG_NAME"] = "설정 모드"
L["OPTIONS_GROUP_CONFIG_DESC"] = "설정 모드로 전환합니다."
L["OPTIONS_GROUP_ANCHOR_NAME"] = "앵커 표시"
L["OPTIONS_GROUP_ANCHOR_DESC"] = "앵커의 표시/숨김을 전환합니다."
L["OPTIONS_GROUP_NAME_NAME"] = "이름"
L["OPTIONS_GROUP_NAME_DESC"] = "그룹 이름을 설정합니다."
L["OPTIONS_GROUP_BARLAYOUT_NAME"] = "바 레이아웃"
L["OPTIONS_GROUP_BARLAYOUT_DESC"] = "그룹의 바에 대한 레이아웃을 설정합니다."
L["OPTIONS_GROUP_BAR_NAME"] = "바"
L["OPTIONS_GROUP_BAR_DESC"] = "상태바를 설정합니다."
L["OPTIONS_GROUP_BAR_SHOW_NAME"] = "상태바 표시"
L["OPTIONS_GROUP_BAR_SHOW_DESC"] = "상태바의 표시/숨김을 전환합니다."
L["OPTIONS_GROUP_BAR_TEXTURE_NAME"] = "바 텍스쳐"
L["OPTIONS_GROUP_BAR_TEXTURE_DESC"] = "바 텍스쳐를 설정합니다."
L["OPTIONS_GROUP_BAR_COLOR_NAME"] = "바 색상"
L["OPTIONS_GROUP_BAR_COLOR_DESC"] = "바 색상을 설정합니다."
L["OPTIONS_GROUP_BAR_BGSHOW_NAME"] = "배경 표시"
L["OPTIONS_GROUP_BAR_BGSHOW_DESC"] = "배경의 표시/숨김을 전환합니다."
L["OPTIONS_GROUP_BAR_BGCOLOR_NAME"] = "배경 색상"
L["OPTIONS_GROUP_BAR_BGCOLOR_DESC"] = "바의 배경에 대한 색상을 설정합니다."
L["OPTIONS_GROUP_BAR_SPARK_NAME"] = "섬광"
L["OPTIONS_GROUP_BAR_SPARK_DESC"] = "섬광 표시를 전환합니다."
L["OPTIONS_GROUP_BAR_DEBUFFCOLOR_NAME"] = "디버프 색상"
L["OPTIONS_GROUP_BAR_DEBUFFCOLOR_DESC"] = "디버프 유형에 따른 색상을 전환합니다."
L["OPTIONS_GROUP_BAR_LTRDIR_NAME"] = "바 방향 전환"
L["OPTIONS_GROUP_BAR_LTRDIR_DESC"] = "바가 왼쪽/오른쪽 시작을 전환합니다."
L["OPTIONS_GROUP_BAR_TIMELESSFULL_NAME"] = "지속 버프 바 채움"
L["OPTIONS_GROUP_BAR_TIMELESSFULL_DESC"] = "지속 버프를 채운 바로 전환합니다."
L["OPTIONS_GROUP_ICON_NAME"] = "아이콘"
L["OPTIONS_GROUP_ICON_DESC"] = "아이콘에 대한 설정입니다."
L["OPTIONS_GROUP_ICON_POSITION_NAME"] = "위치"
L["OPTIONS_GROUP_ICON_POSITION_DESC"] = "아이콘 표시 설정입니다."
L["OPTIONS_GROUP_ICON_POSITION_HIDE"] = "숨김"
L["OPTIONS_GROUP_ICON_POSITION_LEFT"] = "좌측"
L["OPTIONS_GROUP_ICON_POSITION_RIGHT"] = "우측"
L["OPTIONS_GROUP_ICON_STACK_SHOW_NAME"] = "중첩 버프 - 표시"
L["OPTIONS_GROUP_ICON_STACK_SHOW_DESC"] = "아이콘의 중첩 버프에 대한 표시/숨김을 전환합니다."
L["OPTIONS_GROUP_ICON_STACK_ANCHOR_NAME"] = "중첩 버프 - 앵커"
L["OPTIONS_GROUP_ICON_STACK_ANCHOR_DESC"] = "아이콘의 중첩 버프에 대한 앵커 설정입니다."
L["OPTIONS_GROUP_ICON_STACK_FONT_NAME"] = "중첩 버프 - 글꼴"
L["OPTIONS_GROUP_ICON_STACK_FONT_DESC"] = "아이콘의 중첩 버프에 대한 글꼴 설정입니다."
L["OPTIONS_GROUP_ICON_STACK_FONTSIZE_NAME"] = "중첩 버프 - 글꼴 크기"
L["OPTIONS_GROUP_ICON_STACK_FONTSIZE_DESC"] = "아이콘의 중첩 버프에 대한 글꼴 크기 설정입니다."
L["OPTIONS_GROUP_ICON_STACK_FONTCOLOR_NAME"] = "중첩 버프 - 글꼴 색상"
L["OPTIONS_GROUP_ICON_STACK_FONTCOLOR_DESC"] = "아이콘의 중첩 버프에 대한 글꼴 색상 설정입니다."
L["OPTIONS_GROUP_TEXTTL_NAME"] = "상단-좌측 문자"
L["OPTIONS_GROUP_TEXTTL_DESC"] = "상단-좌측 문자의 설정입니다."
L["OPTIONS_GROUP_TEXTTR_NAME"] = "상단-우측 문자"
L["OPTIONS_GROUP_TEXTTR_DESC"] = "상단-우측 문자의 설정입니다."
L["OPTIONS_GROUP_TEXTBL_NAME"] = "하단-좌측 문자"
L["OPTIONS_GROUP_TEXTBL_DESC"] = "하단-좌측 문자의 설정입니다."
L["OPTIONS_GROUP_TEXTBR_NAME"] = "하단-우측 문자"
L["OPTIONS_GROUP_TEXTBR_DESC"] = "하단-우측 문자의 설정입니다."
L["OPTIONS_GROUP_TEXT_TEMPLATE_NAME"] = "문자 표시"
L["OPTIONS_GROUP_TEXT_TEMPLATE_DESC"] = "표시할 문자에 대한 설정입니다."
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_HIDE"] = "숨김"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAME"] = "이름"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANK"] = "이름, 레벨"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMECOUNT"] = "이름, 횟수"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_NAMERANKCOUNT"] = "이름, 레벨, 횟수"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_RANK"] = "레벨"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_COUNT"] = "횟수"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_TIMELEFT"] = "좌측 시간"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_DEBUFFTYPE"] = "디버프 유형"
L["OPTIONS_GROUP_TEXT_TEMPLATE_OPTION_CASTER"] = "시전자"
L["OPTIONS_GROUP_TEXT_FONT_NAME"] = "글꼴"
L["OPTIONS_GROUP_TEXT_FONT_DESC"] = "글꼴을 설정합니다."
L["OPTIONS_GROUP_TEXT_FONTSIZE_NAME"] = "글꼴 크기"
L["OPTIONS_GROUP_TEXT_FONTSIZE_DESC"] = "글꼴 크기를 설정합니다."
L["OPTIONS_GROUP_TEXT_FONTCOLOR_NAME"] = "글꼴 색상"
L["OPTIONS_GROUP_TEXT_FONTCOLOR_DESC"] = "글꼴 색상을 설정합니다."
L["OPTIONS_GROUP_TEXT_STYLE_NAME"] = "글꼴 무늬"
L["OPTIONS_GROUP_TEXT_STYLE_DESC"] = "글꼴 무늬를 변경합니다."
L["OPTIONS_GROUP_TEXT_STYLE_OPTION_PLAIN"] = "외곽선 없음"
L["OPTIONS_GROUP_TEXT_STYLE_OPTION_OUTLINE"] = "가는 외곽선"
L["OPTIONS_GROUP_TEXT_STYLE_OPTION_THICKOUTLINE"] = "굵은 외곽선"
L["OPTIONS_GROUP_TEXT_ALIGNMENT_NAME"] = "정렬"
L["OPTIONS_GROUP_TEXT_ALIGNMENT_LEFT"] = "좌측"
L["OPTIONS_GROUP_TEXT_ALIGNMENT_CENTER"] = "중앙"
L["OPTIONS_GROUP_TEXT_ALIGNMENT_RIGHT"] = "우측"
L["OPTIONS_GROUP_TEXTTL_ALIGNMENT_DESC"] = "문자 정렬을 설정합니다. (상단-좌측 문자가 숨김일시)"
L["OPTIONS_GROUP_TEXTBL_ALIGNMENT_DESC"] = "문자 정렬을 설정합니다. (하단-우측 문자가 숨김일시)"
L["OPTIONS_GROUP_ABBREVIATE_NAME"] = "간략화 이름"
L["OPTIONS_GROUP_ABBREVIATE_DESC"] = "긴 이름을 간략화합니다. (0 = 비활성화)"
L["OPTIONS_GROUP_TIMEFORMAT_NAME"] = "시간 형식"
L["OPTIONS_GROUP_TIMEFORMAT_DESC"] = "표시되는 시간의형식을 설정합니다."
L["OPTIONS_GROUP_TIMEFORMAT_OPTION_DEFAULT"] = "블리자드 기본"
L["OPTIONS_GROUP_TIMEFORMAT_OPTION_CLOCK"] = "시계"
L["OPTIONS_GROUP_TIMEFORMAT_OPTION_CONDENSED"] = "요약"
L["OPTIONS_GROUP_TIMEFRACTION_NAME"] = "짧은 시간 표시"
L["OPTIONS_GROUP_TIMEFRACTION_DESC"] = "지속 시간이 10초미만으로 남을 때 10분의 1초까지 표시합니다."
L["OPTIONS_GROUP_PADDING_NAME"] = "간격"
L["OPTIONS_GROUP_PADDING_DESC"] = "문자열의 간격을 설정합니다."
L["OPTIONS_GROUP_TTIPANCHOR_NAME"] = "툴팁 앵커"
L["OPTIONS_GROUP_TTIPANCHOR_DESC"] = "툴팁의 앵커를 설정합니다."
L["OPTIONS_GROUP_TTIPCASTER_NAME"] = "시전자 툴팁"
L["OPTIONS_GROUP_TTIPCASTER_DESC"] = "주문을 시전한 캐릭터를 효과 툴팁에 표시합니다."
L["OPTIONS_GROUP_HEIGHT_NAME"] = "높이"
L["OPTIONS_GROUP_HEIGHT_DESC"] = "바 높이를 설정합니다."
L["OPTIONS_GROUP_WIDTH_NAME"] = "너비"
L["OPTIONS_GROUP_WIDTH_DESC"] = "바 너비를 설정합니다."
L["OPTIONS_GROUP_ALPHA_NAME"] = "투명도"
L["OPTIONS_GROUP_ALPHA_DESC"] = "그룹의 투명도 값을 설정합니다."
L["OPTIONS_GROUP_SCALE_NAME"] = "크기"
L["OPTIONS_GROUP_SCALE_DESC"] = "그룹의 크기를 설정합니다."
L["OPTIONS_GROUP_BARSPACING_NAME"] = "바 간격"
L["OPTIONS_GROUP_BARSPACING_DESC"] = "바 사이의 공간을 설정합니다."
L["OPTIONS_GROUP_GROWUP_NAME"] = "성장 방향"
L["OPTIONS_GROUP_GROWUP_DESC"] = "버프의 성장 방향을 전환합니다."
L["OPTIONS_GROUP_SORTING_NAME"] = "정렬"
L["OPTIONS_GROUP_SORTING_DESC"] = "버프 정렬을 설정합니다."
L["OPTIONS_GROUP_SORTING_OPTION_TIMELEFT"] = "남은 시간"
L["OPTIONS_GROUP_SORTING_OPTION_TIMEMAX"] = "총 지속 시간"
L["OPTIONS_GROUP_FILTER_NAME"] = "선별"
L["OPTIONS_GROUP_FILTER_DESC"] = "표시할 버프를 설정합니다."
L["OPTIONS_GROUP_FILTER_TYPE_NAME"] = "유형"
L["OPTIONS_GROUP_FILTER_TYPE_DESC"] = "유형에 따른 버프 표시를 설정합니다."
L["OPTIONS_GROUP_FILTER_SELFCAST_NAME"] = "자신의 버프 시전"
L["OPTIONS_GROUP_FILTER_SELFCAST_DESC"] = "당신이 시전한 버프를 선별합니다."
L["OPTIONS_GROUP_FILTER_SELFCAST_OPTION_NOFILTER"] = "선별 않함"
L["OPTIONS_GROUP_FILTER_SELFCAST_OPTION_WHITELIST"] = "화이트리스트"
L["OPTIONS_GROUP_FILTER_SELFCAST_OPTION_BLACKLIST"] = "블랙리스트"
L["OPTIONS_GROUP_FILTER_TIMELESS_NAME"] = "지속적인 버프"
L["OPTIONS_GROUP_FILTER_TIMELESS_DESC"] = "지속적인 버프 선별을 설정합니다."
L["OPTIONS_GROUP_FILTER_TIMELESS_OPTION_NOFILTER"] = "선별 않함"
L["OPTIONS_GROUP_FILTER_TIMELESS_OPTION_WHITELIST"] = "화이트리스트"
L["OPTIONS_GROUP_FILTER_TIMELESS_OPTION_BLACKLIST"] = "블랙리스트"
L["OPTIONS_GROUP_FILTER_TIMEMAXMIN_NAME"] = "최소 시간표시"
L["OPTIONS_GROUP_FILTER_TIMEMAXMIN_DESC"] = "표시할 버프의 최소 시간을 설정합니다."
L["OPTIONS_GROUP_FILTER_TIMEMAXMAX_NAME"] = "최대 시간표시"
L["OPTIONS_GROUP_FILTER_TIMEMAXMAX_DESC"] = "표시할 버프의 최대 시간을 설정합니다."
L["OPTIONS_GROUP_FILTER_NAME_WHITELIST_NAME"] = "화이트 리스트"
L["OPTIONS_GROUP_FILTER_NAME_WHITELIST_DESC"] = "화이트 리스트는 해당 버프만 표시합니다. (선택이 없는 경우에는 전부 표시)"
L["OPTIONS_GROUP_FILTER_NAME_BLACKLIST_NAME"] = "블랙 리스트"
L["OPTIONS_GROUP_FILTER_NAME_BLACKLIST_DESC"] = "블랙 리스트는 표시하지 않을 버프입니다."
L["OPTIONS_GROUP_TARGET_NAME"] = "대상"
L["OPTIONS_GROUP_TARGET_DESC"] = "대상의 버프 표시를 설정합니다."
L["OPTIONS_GROUP_CLICKTHROUGH_NAME"] = "마우스 비활성화"
L["OPTIONS_GROUP_CLICKTHROUGH_DESC"] = "마우스 클릭을 통한 버프 취소를 비활성화 합니다."
L["OPTIONS_GROUP_COPYLAYOUT_NAME"] = "레이아웃 복사"
L["OPTIONS_GROUP_COPYLAYOUT_DESC"] = "다른 바 그룹으로 부터 레이아웃을 복사합니다."
L["OPTIONS_GROUP_COPYLAYOUT_USAGE"] = "레이아웃의 그룹 id"
L["OPTIONS_GROUP_RESETPOSITION_NAME"] = "위치 초기화"
L["OPTIONS_GROUP_RESETPOSITION_DESC"] = "바 그룹의 위치를 화면 중앙으로 초기화 합니다."
L["OPTIONS_GROUP_REMOVE_NAME"] = "그룹 삭제"
L["OPTIONS_GROUP_REMOVE_DESC"] = "바 그룹을 삭제합니다."

L["AURATYPE_BUFF"] = "강화 효과"
L["AURATYPE_DEBUFF"] = "약화 효과"
L["AURATYPE_TENCH"] = "무기 효과" -- nobody knows wtf "tench" means :/
--L["AURATYPE_TRACKING"] = "Tracking"

L["ANCHOR_DEFAULT"] = "블리자드 기본"
L["ANCHOR_TOPLEFT"] = "왼쪽 위"
L["ANCHOR_TOP"] = "가운데 위"
L["ANCHOR_TOPRIGHT"] = "오른쪽 위"
L["ANCHOR_LEFT"] = "왼쪽"
L["ANCHOR_CENTER"] = "가운데"
L["ANCHOR_RIGHT"] = "오른쪽"
L["ANCHOR_BOTTOMLEFT"] = "왼쪽 아래"
L["ANCHOR_BOTTOM"] = "가운데 아래"
L["ANCHOR_BOTTOMRIGHT"] = "오른쪽 아래"
L["ANCHOR_CURSOR"] = "커서"
L["ANCHOR_PRESERVE"] = "지킴"
L["ANCHOR_NONE"] = "없음"

L["UNIT_VEHICLE"] = "탈 것"
