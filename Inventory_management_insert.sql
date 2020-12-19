insert into stock
values(stock_id_seq.nextval, 'A4����', 10, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A3����', 12, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A2����', 15, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A5����', 8, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'B4����', 14, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'B5����', 11, 'material', null);
insert into stock
values(stock_id_seq.nextval, '���̾', 100, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'pvcĿ��', 150, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A5������å', 0, 'product', 2000);
insert into stock
values(stock_id_seq.nextval, 'B5������ ��å', 0, 'product', 3000);
insert into stock
values(stock_id_seq.nextval, '��������', 760, 'goods', 1000);
insert into stock
values(stock_id_seq.nextval, '���찳', 170, 'goods', 300);

insert into manufacturer
values('ȣ������', '010-8788-6569', '�λ� ������', 'Cave Johnson');
insert into manufacturer
values('���ǹ���', '010-1234-1234', '�λ� ������', '�赿��');
insert into manufacturer
values('ERD Chemical', '010-3322-2134', '��� �ϱ�', '������');

insert into supply(stock_id, mfr_name, quantity)
values(1, 'ȣ������', 3000);
insert into supply(stock_id, mfr_name, quantity)
values(2, 'ȣ������', 2000);
insert into supply(stock_id, mfr_name, quantity)
values(3, 'ȣ������', 3000);
insert into supply(stock_id, mfr_name, quantity)
values(4, 'ȣ������', 2500);
insert into supply(stock_id, mfr_name, quantity)
values(5, 'ȣ������', 1500);
insert into supply(stock_id, mfr_name, quantity)
values(6, 'ȣ������', 3000);
insert into supply(stock_id, mfr_name, quantity)
values(7, '���ǹ���', 200);
insert into supply(stock_id, mfr_name, quantity)
values(8, '���ǹ���', 200);
insert into supply(stock_id, mfr_name, quantity)
values(11, '���ǹ���', 500);
insert into supply(stock_id, mfr_name, quantity)
values(12, 'ERD Chemical', 200);

insert into release(stock_id, release_quantity)
values(11, 13);
insert into release(stock_id, release_quantity)
values(11, 5);
insert into release(stock_id, release_quantity)
values(11, 9);
insert into release(stock_id, release_quantity)
values(12, 8);
insert into release(stock_id, release_quantity)
values(12, 22);
insert into release(stock_id, release_quantity)
values(12, 8);
insert into release(stock_id, release_quantity)
values(10, 3);
insert into release(stock_id, release_quantity)
values(10, 5);
insert into release(stock_id, release_quantity)
values(9, 22);

insert into product
values(9, 4, 20);
insert into product
values(9, 7, 1);
insert into product
values(9, 8, 1);
insert into product
values(10, 6, 40);
insert into product
values(10, 7, 1);
insert into product
values(10, 8, 1);

insert into preset
values(preset_id_seq.nextval, '��������Ʈ+���� ��Ʈ');

insert into preset_list
values(2, 10);
insert into preset_list
values(2, 11);

insert into account
values('admin', '0000', '������', '������', 0);
insert into account
values('manager', '0000', 'ȫ�浿', '�Ŵ���', 4);
insert into account
values('testid2', '1234', 'testname', '�׽���', 8);

insert into menu
values(1, '����� ���� ����', 0);
insert into menu
values(2, '�޴� ���� ����', 9);
insert into menu
values(3, '����� ���', 9);
insert into menu
values(4, '���� ��ȸ', 4);
insert into menu
values(5, '��ǰ ����', 9);
insert into menu
values(6, '������', 4);
insert into menu
values(7, '���� ��ȸ', 9);
insert into menu
values(8, '��� �м�', 4);