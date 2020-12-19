-- ���� ���̺� ����
create table account(
    acc_id varchar2(15) constraint tb_account_id_pk primary key not null,
    acc_pw varchar2(20) not null,
    acc_name varchar2(20) not null,
    acc_position varchar2(20),
    acc_auth number default 9 not null
);

-- �޴� ���̺� ����
create table menu(
    menu_id number constraint tb_menu_id_pk primary key not null,
    menu_name varchar2(20) not null,
    menu_auth number default 0 not null
);

-- ��ǰ ���̺� ����, ���� �������� product, material, goods
create table stock(
    stock_id number constraint tb_stock_id_pk primary key not null,
    stock_name varchar2(30) not null,
    stock_cost number default 0 not null,
    stock_division varchar2(10) not null,
    stock_saleprice number,
    constraint division_check check(stock_division in('product', 'material', 'goods'))
);

-- division = product�� stock_id�� ����Ǵ� ���̺�
create table stock_product(
    product_id number not null,
    constraint stock_product_pk primary key(product_id),
    constraint stock_product_fk foreign key(product_id) references stock(stock_id)
);
-- division = material�� stock_id�� ����Ǵ� ���̺�
create table stock_material(
    material_id number not null,
    constraint stock_material_pk primary key(material_id),
    constraint stock_material_fk foreign key(material_id) references stock(stock_id)
);
-- division = goods�� stock_id�� ����Ǵ� ���̺�
create table stock_goods(
    goods_id number not null,
    constraint stock_goods_pk primary key(goods_id),
    constraint stock_goods_fk foreign key(goods_id) references stock(stock_id)
);

-- stock_id ������ ������
create sequence stock_id_seq
start with 1 increment by 1;
-- ������ �ʱ�ȭ
drop sequence stock_id_seq;

-- Ʈ���� ���� stock�� ��ǰ�� insert, delete, update�� �� �ڵ����� stock_product, stock_material, stock_goods�� stock_id�� ����
create or replace trigger stock_div_classification
    after insert or delete or update on stock -- ����, ����, ������Ʈ�ɶ�
    for each row
begin
    if inserting then -- �߰��Ҷ�
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
    if updating then -- ������Ʈ�Ҷ�
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
    if deleting then -- �����Ҷ�
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
-- Ʈ���� ��!

create table product( -- ���� ���̺� ����, product���̺�� material ���̺��� ���� ����
    product_id number not null,
    material_id number not null,
    made_quantity number default 1 not null,
    constraint tb_product_product_id_fk
    foreign key (product_id) references stock_product(product_id),
    constraint tb_product_material_id_fk
    foreign key (material_id) references stock_material(material_id)
);

create table supply( --  �԰� ���̺� ����, stock ���̺�� manufacturer ���̺��� ���� ����
    stock_id number not null,
    mfr_name varchar2(20) not null,
    supply_date date default sysdate,
    quantity number not null,
    constraint supply_stock_id_fk
    foreign key(stock_id) references stock(stock_id),
    constraint supply_mfr_name_fk
    foreign key(mfr_name) references manufacturer(mfr_name)
);

create table manufacturer( -- ������ ���̺� ����
    mfr_name varchar2(20) constraint manufacturer_name_pk primary key not null,
    mfr_tel varchar2(15),
    mfr_loc varchar2(40),
    mfr_manager varchar2(20)
);

create table release( -- ��� ���̺� ����, stock ���̺� ����
    stock_id number not null,
    release_quantity number not null,
    release_date date default sysdate not null,
    constraint release_stock_id_fk
    foreign key(stock_id) references stock(stock_id)
);

-- preset_id ������ ������
create sequence preset_id_seq
start with 1 increment by 1;
-- ������ �ʱ�ȭ
drop sequence preset_id_seq;

create table preset( -- ������ ���̺� ����
    preset_id number constraint preset_id_pk primary key not null,
    preset_name varchar2(20)
);

create table preset_list( -- ������ ��� ���̺� ����, preset���̺�� stock ���̺� ����
    preset_id number not null,
    stock_id number not null,
    constraint preset_list_preset_id_fk
    foreign key(preset_id) references preset(preset_id),
    constraint preset_list_stock_id_fk
    foreign key(stock_id) references stock(stock_id)
);

-- �Ǹ� �� ����. stock ���̺�� release ���̺� ����
create view vw_sales as
select
    st.stock_id as "��ǰ�ĺ���ȣ",
    rl.release_date as "�Ǹ���",
    rl.release_quantity as "�Ǹż���",
    (rl.release_quantity * st.stock_saleprice) as "�Ǹűݾ�",
    (rl.release_quantity * st.stock_saleprice)
    -(rl.release_quantity * st.stock_cost)-(rl.release_quantity * nvl((
        select sum(prd.made_quantity * stk.stock_cost)
        from stock stk, product prd
        where stk.stock_id = prd.material_id
        group by product_id
        having product_id = st.stock_id
    ), 0)) as "����"
from stock st, release rl
where st.stock_id = rl.stock_id;

select * from vw_sales;
    


-- ��� �� ����, stock, release, supply ���̺� ���� �� ��� view ����, ���� ��� view�� ��ǰ��� ������ �ٿ��ִ� view �߰�
create view vw_qtt as
select st.stock_id, nvl(sum(sp.supply_quantity),0) - nvl(sum(rl.release_quantity),0) as "sumqtt"
from supply sp left outer join stock st 
on sp.stock_id = st.stock_id
left outer join release rl
on st.stock_id = rl.stock_id
group by st.stock_id;

create view vw_inventory as
select qt.stock_id, qt."sumqtt" as "���", st.stock_name as "��ǰ��", st.stock_division as "����", sp.mfr_name as "������"
from stock st, vw_qtt qt, supply sp
where st.stock_id = qt.stock_id and st.stock_id = sp.stock_id
order by stock_id;

--  �׼��� �� ����, account, menu ���̺� ����
create view vw_access as
select ac.acc_id, mn.menu_name
from account ac, menu mn
where ac.acc_auth <= mn.menu_auth;

-- ���� �� ����

create view vw_product as
select st.stock_id as product_id, st.stock_name as "��ǰ��", st2.stock_id as material_id, st2.stock_name as "������", pr.made_quantity as "�ʿ����"
from stock st, stock st2, product pr
where pr.product_id = st.stock_id and pr.material_id = st2.stock_id
order by pr.product_id, pr.material_id desc;

-- ������ �� ����

create view vw_preset as
select prs.preset_name, st.stock_name
from preset prs, stock st, preset_list prl
where prs.preset_id = prl.preset_id and prl.stock_id = st.stock_id;