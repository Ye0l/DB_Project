-- 계정 테이블
select * from account;
-- 메뉴 테이블
select * from menu;
-- 계정별로 액세스 가능한 메뉴를 표시하는 뷰. 계정과 메뉴 테이블 조인으로 제작.
select ac.acc_id, mn.menu_name
from account ac, menu mn
where ac.acc_auth <= mn.menu_auth
and ac.acc_id = 'admin';

select * from vw_access where acc_id = 'manager';

-- 물품 테이블
select * from stock;
-- 물품-제품 테이블
select * from stock_product;
-- 물품-원자재 테이블
select * from stock_material;
-- 물품-상품 테이블
select * from stock_goods;
-- 제조 테이블
select * from product;
-- 제조 테이블과 물품 테이블에 조인한 제품별 필요 재료 확인 뷰
select
    st.stock_id as product_id,
    st.stock_name as "제품명",
    st2.stock_id as material_id,
    st2.stock_name as "원재료명",
    pr.made_quantity as "필요수량"
from stock st, stock st2, product pr
where pr.product_id = st.stock_id and pr.material_id = st2.stock_id
order by pr.product_id, pr.material_id desc;

select * from vw_product;

-- 제조업체 테이블
select * from manufacturer;
-- 입고 테이블
select * from supply;
-- 출고 테이블
select * from release;
-- 물품, 입고, 출고 테이블에 조인하는 재고 뷰
-- left join을 먼저 한 view를 다시 물품 테이블과 join후 뷰로 제작
select
    st.stock_id,
    nvl(sum(sp.supply_quantity),0) - nvl(sum(rl.release_quantity),0) as sumqtt
from supply sp left outer join stock st 
on sp.stock_id = st.stock_id
left outer join release rl
on st.stock_id = rl.stock_id
group by st.stock_id;

select * from vw_qtt;

select
    qt.stock_id, qt."sumqtt" as "재고량",
    st.stock_name as "물품명",
    st.stock_division as "구분",
    sp.mfr_name as "제조사"
from stock st, vw_qtt qt, supply sp
where st.stock_id = qt.stock_id and st.stock_id = sp.stock_id
order by stock_id;

select * from vw_inventory;

-- 판매 뷰, 출고 테이블과 물품 테이블 조인으로 제작
select
    st.stock_id as "식별번호",
    rl.release_date as "판매일",
    rl.release_quantity as "판매수량",
    (rl.release_quantity * st.stock_cost) as "판매금액"
from stock st, release rl
where st.stock_id = rl.stock_id;

select * from vw_sales;

-- 프리셋 테이블
select * from preset;
-- 프리셋 요소 테이블
select * from preset_list;
-- 프리셋과 묶인 상품을 보여주는 뷰
select prs.preset_name, st.stock_name
from preset prs, stock st, preset_list prl
where prs.preset_id = prl.preset_id and prl.stock_id = st.stock_id;

select * from vw_preset;

-- 물품 추가, 수정, 삭제 시연 (트리거 작동)
-- 추가
select * from stock;
select * from stock_material;

insert into stock(stock_id, stock_name, stock_cost, stock_division)
values(STOCK_ID_SEQ.nextval, '이어폰', 20000, 'goods');
-- stock 테이블 추가 확인
select *  from stock;
-- stock_goods 테이블 추가 확인
select * from stock_goods;
select * from stock_product;
-- 수정
update stock set stock_division = 'product' where stock_name = '이어폰';
-- 삭제
delete stock where stock_name = '이어폰';