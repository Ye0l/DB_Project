-- ���� ���̺�
select * from account;
-- �޴� ���̺�
select * from menu;
-- �������� �׼��� ������ �޴��� ǥ���ϴ� ��. ������ �޴� ���̺� �������� ����.
select ac.acc_id, mn.menu_name
from account ac, menu mn
where ac.acc_auth <= mn.menu_auth
and ac.acc_id = 'admin';

select * from vw_access where acc_id = 'manager';

-- ��ǰ ���̺�
select * from stock;
-- ��ǰ-��ǰ ���̺�
select * from stock_product;
-- ��ǰ-������ ���̺�
select * from stock_material;
-- ��ǰ-��ǰ ���̺�
select * from stock_goods;
-- ���� ���̺�
select * from product;
-- ���� ���̺�� ��ǰ ���̺� ������ ��ǰ�� �ʿ� ��� Ȯ�� ��
select
    st.stock_id as product_id,
    st.stock_name as "��ǰ��",
    st2.stock_id as material_id,
    st2.stock_name as "������",
    pr.made_quantity as "�ʿ����"
from stock st, stock st2, product pr
where pr.product_id = st.stock_id and pr.material_id = st2.stock_id
order by pr.product_id, pr.material_id desc;

select * from vw_product;

-- ������ü ���̺�
select * from manufacturer;
-- �԰� ���̺�
select * from supply;
-- ��� ���̺�
select * from release;
-- ��ǰ, �԰�, ��� ���̺� �����ϴ� ��� ��
-- left join�� ���� �� view�� �ٽ� ��ǰ ���̺�� join�� ��� ����
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
    qt.stock_id, qt."sumqtt" as "���",
    st.stock_name as "��ǰ��",
    st.stock_division as "����",
    sp.mfr_name as "������"
from stock st, vw_qtt qt, supply sp
where st.stock_id = qt.stock_id and st.stock_id = sp.stock_id
order by stock_id;

select * from vw_inventory;

-- �Ǹ� ��, ��� ���̺�� ��ǰ ���̺� �������� ����
select
    st.stock_id as "�ĺ���ȣ",
    rl.release_date as "�Ǹ���",
    rl.release_quantity as "�Ǹż���",
    (rl.release_quantity * st.stock_cost) as "�Ǹűݾ�"
from stock st, release rl
where st.stock_id = rl.stock_id;

select * from vw_sales;

-- ������ ���̺�
select * from preset;
-- ������ ��� ���̺�
select * from preset_list;
-- �����°� ���� ��ǰ�� �����ִ� ��
select prs.preset_name, st.stock_name
from preset prs, stock st, preset_list prl
where prs.preset_id = prl.preset_id and prl.stock_id = st.stock_id;

select * from vw_preset;

-- ��ǰ �߰�, ����, ���� �ÿ� (Ʈ���� �۵�)
-- �߰�
select * from stock;
select * from stock_material;

insert into stock(stock_id, stock_name, stock_cost, stock_division)
values(STOCK_ID_SEQ.nextval, '�̾���', 20000, 'goods');
-- stock ���̺� �߰� Ȯ��
select *  from stock;
-- stock_goods ���̺� �߰� Ȯ��
select * from stock_goods;
select * from stock_product;
-- ����
update stock set stock_division = 'product' where stock_name = '�̾���';
-- ����
delete stock where stock_name = '�̾���';