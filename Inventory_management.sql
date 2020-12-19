-- 계정 테이블 생성
create table account(
    acc_id varchar2(15) constraint tb_account_id_pk primary key not null,
    acc_pw varchar2(20) not null,
    acc_name varchar2(20) not null,
    acc_position varchar2(20),
    acc_auth number default 9 not null
);

-- 메뉴 테이블 생성
create table menu(
    menu_id number constraint tb_menu_id_pk primary key not null,
    menu_name varchar2(20) not null,
    menu_auth number default 0 not null
);

-- 물품 테이블 생성, 구분 제약조건 product, material, goods
create table stock(
    stock_id number constraint tb_stock_id_pk primary key not null,
    stock_name varchar2(30) not null,
    stock_cost number default 0 not null,
    stock_division varchar2(10) not null,
    stock_saleprice number,
    constraint division_check check(stock_division in('product', 'material', 'goods'))
);

-- division = product인 stock_id만 저장되는 테이블
create table stock_product(
    product_id number not null,
    constraint stock_product_pk primary key(product_id),
    constraint stock_product_fk foreign key(product_id) references stock(stock_id)
);
-- division = material인 stock_id만 저장되는 테이블
create table stock_material(
    material_id number not null,
    constraint stock_material_pk primary key(material_id),
    constraint stock_material_fk foreign key(material_id) references stock(stock_id)
);
-- division = goods인 stock_id만 저장되는 테이블
create table stock_goods(
    goods_id number not null,
    constraint stock_goods_pk primary key(goods_id),
    constraint stock_goods_fk foreign key(goods_id) references stock(stock_id)
);

-- stock_id 설정용 시퀀스
create sequence stock_id_seq
start with 1 increment by 1;
-- 시퀀스 초기화
drop sequence stock_id_seq;

-- 트리거 생성 stock에 제품이 insert, delete, update될 때 자동으로 stock_product, stock_material, stock_goods에 stock_id를 수정
create or replace trigger stock_div_classification
    after insert or delete or update on stock -- 생성, 삭제, 업데이트될때
    for each row
begin
    if inserting then -- 추가할때
        if :new.stock_division = 'product' then
            insert into stock_product
            values(:new.stock_id);
        end if;
        if :new.stock_division = 'material' then
            insert into stock_material
            values(:new.stock_id);
        end if;
        if :new.stock_division = 'goods' then
            insert into stock_goods
            values(:new.stock_id);
        end if;
    end if;
    if updating then -- 업데이트할때
        if :new.stock_division = 'product' then
            if :old.stock_division = 'material' then
                delete from stock_material where material_id = :new.stock_id;
                insert into stock_product values(:new.stock_id);
            elsif :old.stock_division = 'goods' then
                delete from stock_goods where goods_id = :new.stock_id;
                insert into stock_product values(:new.stock_id);
            end if;
        end if;
        if :new.stock_division = 'material' then
            if :old.stock_division = 'product' then
                delete from stock_product where product_id = :new.stock_id;
                insert into stock_material values(:new.stock_id);
            elsif :old.stock_division = 'goods' then
                delete from stock_goods where goods_id = :new.stock_id;
                insert into stock_material values(:new.stock_id);
            end if;
        end if;
        if :new.stock_division = 'goods' then
            if :old.stock_division = 'product' then
                delete from stock_product where product_id = :new.stock_id;
                insert into stock_goods values(:new.stock_id);
            elsif :old.stock_division = 'material' then
                delete from stock_material where material_id = :new.stock_id;
                insert into stock_goods values(:new.stock_id);
            end if;
        end if;
    end if;
    if deleting then -- 삭제할때
        if :old.stock_division = 'product' then
            delete from stock_product where product_id = :old.stock_id;
        elsif :old.stock_division = 'material' then
            delete from stock_material where material_id = :old.stock_id;
        elsif :old.stock_division = 'goods' then
            delete from stock_goods where goods_id = :old.stock_id;
        end if;
    end if;
end;
/
-- 트리거 끝!

create table product( -- 제조 테이블 생성, product테이블과 material 테이블에서 각각 참조
    product_id number not null,
    material_id number not null,
    made_quantity number default 1 not null,
    constraint tb_product_product_id_fk
    foreign key (product_id) references stock_product(product_id),
    constraint tb_product_material_id_fk
    foreign key (material_id) references stock_material(material_id)
);

create table supply( --  입고 테이블 생성, stock 테이블과 manufacturer 테이블에서 각각 참조
    stock_id number not null,
    mfr_name varchar2(20) not null,
    supply_date date default sysdate,
    quantity number not null,
    constraint supply_stock_id_fk
    foreign key(stock_id) references stock(stock_id),
    constraint supply_mfr_name_fk
    foreign key(mfr_name) references manufacturer(mfr_name)
);

create table manufacturer( -- 제조사 테이블 생성
    mfr_name varchar2(20) constraint manufacturer_name_pk primary key not null,
    mfr_tel varchar2(15),
    mfr_loc varchar2(40),
    mfr_manager varchar2(20)
);

create table release( -- 출고 테이블 생성, stock 테이블 참조
    stock_id number not null,
    release_quantity number not null,
    release_date date default sysdate not null,
    constraint release_stock_id_fk
    foreign key(stock_id) references stock(stock_id)
);

-- preset_id 설정용 시퀀스
create sequence preset_id_seq
start with 1 increment by 1;
-- 시퀀스 초기화
drop sequence preset_id_seq;

create table preset( -- 프리셋 테이블 생성
    preset_id number constraint preset_id_pk primary key not null,
    preset_name varchar2(20)
);

create table preset_list( -- 프리셋 목록 테이블 생성, preset테이블과 stock 테이블 참조
    preset_id number not null,
    stock_id number not null,
    constraint preset_list_preset_id_fk
    foreign key(preset_id) references preset(preset_id),
    constraint preset_list_stock_id_fk
    foreign key(stock_id) references stock(stock_id)
);

-- 판매 뷰 생성. stock 테이블과 release 테이블 조인
create view vw_sales as
select
    st.stock_id as "물품식별번호",
    rl.release_date as "판매일",
    rl.release_quantity as "판매수량",
    (rl.release_quantity * st.stock_saleprice) as "판매금액",
    (rl.release_quantity * st.stock_saleprice)
    -(rl.release_quantity * st.stock_cost)-(rl.release_quantity * nvl((
        select sum(prd.made_quantity * stk.stock_cost)
        from stock stk, product prd
        where stk.stock_id = prd.material_id
        group by product_id
        having product_id = st.stock_id
    ), 0)) as "이익"
from stock st, release rl
where st.stock_id = rl.stock_id;

select * from vw_sales;
    


-- 재고 뷰 생성, stock, release, supply 테이블 조인 후 재고 view 생성, 이후 재고 view에 물품명과 구분을 붙여주는 view 추가
create view vw_qtt as
select st.stock_id, nvl(sum(sp.supply_quantity),0) - nvl(sum(rl.release_quantity),0) as "sumqtt"
from supply sp left outer join stock st 
on sp.stock_id = st.stock_id
left outer join release rl
on st.stock_id = rl.stock_id
group by st.stock_id;

create view vw_inventory as
select qt.stock_id, qt."sumqtt" as "재고량", st.stock_name as "물품명", st.stock_division as "구분", sp.mfr_name as "제조사"
from stock st, vw_qtt qt, supply sp
where st.stock_id = qt.stock_id and st.stock_id = sp.stock_id
order by stock_id;

--  액세스 뷰 생성, account, menu 테이블 조인
create view vw_access as
select ac.acc_id, mn.menu_name
from account ac, menu mn
where ac.acc_auth <= mn.menu_auth;

-- 제조 뷰 생성

create view vw_product as
select st.stock_id as product_id, st.stock_name as "제품명", st2.stock_id as material_id, st2.stock_name as "원재료명", pr.made_quantity as "필요수량"
from stock st, stock st2, product pr
where pr.product_id = st.stock_id and pr.material_id = st2.stock_id
order by pr.product_id, pr.material_id desc;

-- 프리셋 뷰 생성

create view vw_preset as
select prs.preset_name, st.stock_name
from preset prs, stock st, preset_list prl
where prs.preset_id = prl.preset_id and prl.stock_id = st.stock_id;