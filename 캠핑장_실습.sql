SELECT *
FROM camping_info;

SELECT count(*)
FROM camping_info;

/*[실습01]
1. 캠핑장의 사업장명과 지번주소를 출력(단, 사업장명은 NAME, 지번주소는 ADDRESS로 출력)
2. 1번 데이터에서 정상 영업 하고 있는 캠핑장만 출력
3. 양양에 위치한 캠핑장은 몇 개인지 출력
4. 3번 데이터에서 폐업한 캠핑장은 몇 개인지 출력
5. 태안에 위치한 캠핑장의 사업장명 출력
6. 5번 데이터에서 2020년에 폐업한 캠핑장만 출력
7. 제주도와 서울에 위치한 캠핑장은 몇 개인지 출력
*/

-- 1.캠핑장의 사업장명과 지번주소를 출력(단, 사업장명은 NAME, 지번주소는 ADDRESS로 출력)
SELECT 사업장명 AS name, 지번주소 AS address
FROM camping_info;

-- 2. 1번 데이터에서 정상 영업하고 있는 캠핑장만 출력
SELECT 사업장명 AS 캠핑장_이름, 영업상태명, 상세영업상태명
FROM camping_info
WHERE 영업상태명 = '영업/정상' AND 상세영업상태명 = '영업중';

-- 3. 양양에 위치한 캠핑장은 몇 개인지 출력
SELECT count(*) AS 양양_캠핑장_갯수
FROM camping_info
WHERE substring(지번주소, 9,2) = '양양';

-- 4. 3번 데이터에서 폐업한 캠핑장은 몇 개인지 출력
SELECT count(*) AS 양양_캠핑장_폐업_갯수
FROM camping_info
WHERE 지번주소
LIKE '%양양%'
AND 상세영업상태명 = '폐업';

-- 5. 태안에 위치한 캠핑장의 사업장명 출력
SELECT 지번주소, 사업장명
FROM camping_info
WHERE 지번주소
LIKE '%태안%';

-- 6. 5번 데이터에서 2020년에 폐업한 캠핑장만 출력
SELECT 사업장명, 지번주소
FROM camping_info
WHERE 지번주소
LIKE '%태안%'
AND 폐업일자 like '%2020%';

-- 7. 제주도와 서울에 위치한 캠핑장은 몇 개인지 출력
SELECT count(*) AS 제주도_서울_캠핑장_갯수
FROM camping_info
WHERE 지번주소 LIKE '%제주특별자치도%' or 지번주소 like '%서울특별시%';

-- 폐업이 아닌 경우
SELECT *
FROM camping_info
WHERE 상세영업상태코드 != 3;

/* [실습02]
1. 해수욕장에 위치한 캠핑장의 사업장명과 인허가일자를 출력
2. 제주도 해수욕장에 위치한 캠핑장의 지번주소와 사업장명 출력
3. 2번 데이터에서 인허가일자가 가장 최근인 곳의 인허가일자 출력
4. 인천 해수욕장에 위치한 캠핑장 중 영업중인 곳만 출력
5. 4번 데이터 중에서 인허가일자가 가장 오래된 곳의 인허가일자 출력
6. 해수욕장에 위치한 캠핑장 중 시설면적이 가장 넓은 곳의 시설면적 출력
7. 해수욕장에 위치한 캠핑장의 평균 시설면적 출력
*/

-- 1. 해수욕장에 위치한 캠핑장의 사업장명과 인허가일자를 출력
SELECT 사업장명 AS camping_site, 인허가일자
FROM camping_info
WHERE 지번주소 LIKE '%해수%' OR 도로명주소 LIKE '%해수%';

-- 2. 제주도 해수욕장에 위치한 캠핑장의 지번주소와 사업장명 출력
SELECT 지번주소, 사업장명
FROM camping_info
WHERE 지번주소 LIKE '%제주특별자치도%'
AND (사업장명 LIKE '%해수%' OR 지번주소 LIKE '%해수%' OR 도로명주소 LIKE '%해수%');

-- 3. 2번 데이터에서 인허가일자가 가장 최근인 곳의 인허가일자 출력
SELECT 사업장명, 인허가일자
FROM camping_info
WHERE 지번주소 LIKE '%제주특별자치도%'
AND (
사업장명
LIKE '%해수%'
OR 지번주소
LIKE '%해수%'
OR 도로명주소
LIKE '%해수%')
ORDER BY 인허가일자 DESC -- 이거는 무조건 하나만 나옴
LIMIT 1; -- max로도 표현 가능, subquery 가능

SELECT 사업장명, 인허가일자 -- max 값이 두개면 두개 다 나옴
FROM camping_info
WHERE 사업장명 LIKE '%해수욕장%'
AND 지번주소 LIKE '%제주%'
AND 인허가일자 = (
	SELECT MAX(인허가일자)
	FROM camping_info
	WHERE 사업장명 LIKE '%해수욕장%'
	AND 지번주소 LIKE '%제주%'
);


-- 4. 인천 해수욕장에 위치한 캠핑장 중 영업중인 곳만 출력
SELECT 사업장명
FROM camping_info
WHERE 지번주소 LIKE '인천%'
AND (
사업장명
LIKE '%해수%'
OR 지번주소
LIKE '%해수%'
OR 도로명주소
LIKE '%해수%')
AND 상세영업상태코드 =13 ;

-- 5. 4번 데이터 중에서 인허가일자가 가장 오래된 곳의 인허가일자 출력
SELECT 사업장명, 인허가일자
FROM camping_info
WHERE 지번주소 LIKE '인천%'
AND (
사업장명
LIKE '%해수%'
OR 지번주소
LIKE '%해수%'
OR 도로명주소
LIKE '%해수%')
AND 상세영업상태코드 = 13
ORDER BY 인허가일자 DESC
LIMIT 1;

-- 6. 해수욕장에 위치한 캠핑장 중 시설면적이 가장 넓은 곳의 시설면적 출력
SELECT max(시설면적)
FROM camping_info
WHERE 사업장명
LIKE '%해수%';

-- ★ 7. 해수욕장에 위치한 캠핑장의 평균 시설면적 출력
SELECT AVG(시설면적) AS 평균_시설면적
FROM camping_info
WHERE 사업장명 LIKE '%해수욕장%'
AND 시설면적 IS NOT NULL;
-- 주의해야 될 점 : 시설면적이 NULL은 제외하고 계산

/*
[실습03]
1. 캠핑장의 사업장명, 시설면적을 시설면적이 가장 넓은 순으로 출력
2. 1번 데이터에서 10위까지만 출력
3. 경기도 캠핑장 중에 면적이 가장 넓은 순으로 5개만 출력
4. 3번 데이터에서 1위는 제외
5. 영업중인 캠핑장 중에서 인허가일자가 가장 오래된 순으로 20개 출력
6. 2020년 10월 ~2021년 3월 사이에 폐업한 캠핑장의 사업장명과 지번주소 출력
7. 폐업한 캠핑장 중에서 시설면적이 가장 컷던 곳의 사업장명과 시설면적 출력
*/

-- 1. 캠핑장의 사업장명, 시설면적을 시설면적이 가장 넓은 순으로 출력
SELECT 사업장명, 시설면적
FROM camping_info
order BY 시설면적 DESC;

-- 2. 1번 데이터에서 10위까지만 출력
SELECT 사업장명, 시설면적
FROM camping_info
order BY 시설면적 DESC
LIMIT 10;

-- 3. 경기도 캠핑장 중에 면적이 가장 넓은 순으로 5개만 출력
SELECT 사업장명, 시설면적
FROM camping_info
WHERE 지번주소 LIKE '경기도%'
order BY 시설면적 DESC
LIMIT 5;

-- ☆ 4. 3번 데이터에서 1위는 제외
SELECT 사업장명, 시설면적
FROM camping_info
WHERE 지번주소 LIKE '경기도%'
order BY 시설면적 DESC
LIMIT 1, 4; -- 2개 써주면, 시작위치(1)와 출력하는 데이터 갯수(4)

-- 5. 영업중인 캠핑장 중에서 인허가일자가 가장 오래된 순으로 20개 출력
SELECT *
FROM camping_info
WHERE 상세영업상태코드 = 13
ORDER BY 인허가일자 DESC
LIMIT 20;

-- 6. 2020년 10월 ~2021년 3월 사이에 폐업한 캠핑장의 사업장명과 지번주소 출력
SELECT 사업장명, 지번주소, 폐업일자
FROM camping_info
WHERE 폐업일자 BETWEEN '2020-10-01'
		    AND '2021-03-31';

-- 7. 폐업한 캠핑장 중에서 시설면적이 가장 컷던 곳의 사업장명과 시설면적 출력
SELECT 사업장명, 시설면적, 폐업일자
FROM camping_info
WHERE 상세영업상태코드 = 3
ORDER BY 시설면적 DESC
LIMIT 1;

/*
[실습04]
1. 각 지역별 캠핑장 수 출력 (단, 지역은 LOCATION으로 출력)
2. 1번 데이터를 캠핑장 수가 많은 지역부터 출력
3. 각 지역별 영업중인 캠핑장 수 출력
4. 3번 데이터에서 캠핑장 수가 300개 이상인 지역만 출력
5. 년도별 폐업한 캠핑장 수 출력 (단, 년도는 YEAR로 출력)
6. 5번 데이터를 년도별로 내림차순하여 출력
*/ 

-- 1. 각 지역별 캠핑장 수 출력 (단, 지역은 LOCATION으로 출력)
SELECT LEFT(지번주소, 2) AS LOCATION, count(*) AS 캠핑장_수
FROM camping_info
GROUP BY LEFT(지번주소, 2);

-- 이거 아니면 instr(지번주소, '')가 더 명확한 형태
-- (공백이 처음 나타나는 위치 첫 번째 자리를 리턴)

SELECT substr(지번주소, 1, instr(지번주소, ' ')) AS LOCATION,
count(*) AS 캠핑장_수
FROM camping_info
GROUP BY location
ORDER BY count(*) desc;

-- 2. 1번 데이터를 캠핑장 수가 많은 지역부터 출력
SELECT LEFT(지번주소, 2) AS LOCATION, count(*) AS 캠핑장_수
FROM camping_info
GROUP BY LEFT(지번주소, 2)
ORDER BY 캠핑장_수 DESC;

-- 3. 각 지역별 영업중인 캠핑장 수 출력
SELECT LEFT(지번주소, 2) AS LOCATION, count(*) AS 캠핑장_수
FROM camping_info
WHERE 상세영업상태코드 = 13
GROUP BY LEFT(지번주소, 2);

-- ★ 4. 3번 데이터에서 캠핑장 수가 300개 이상인 지역만 출력
SELECT LEFT(지번주소, 2) AS LOCATION, count(*) AS 캠핑장_수
FROM camping_info
WHERE 상세영업상태코드 = 13
GROUP BY LEFT(지번주소, 2)
HAVING count(*) >= 300;

-- 5. 년도별 폐업한 캠핑장 수 출력 (단, 년도는 YEAR로 출력)
SELECT substr(폐업일자, 1, 4) AS YEAR,
	count(*) AS 캠핑장_수
FROM camping_info
WHERE 상세영업상태코드 = 3
GROUP BY YEAR
ORDER BY YEAR desc; -- 6번 내용