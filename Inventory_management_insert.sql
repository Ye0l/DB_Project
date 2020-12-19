insert into stock
values(stock_id_seq.nextval, 'A4용지', 10, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A3용지', 12, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A2용지', 15, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A5용지', 8, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'B4용지', 14, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'B5용지', 11, 'material', null);
insert into stock
values(stock_id_seq.nextval, '와이어링', 100, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'pvc커버', 150, 'material', null);
insert into stock
values(stock_id_seq.nextval, 'A5무선공책', 0, 'product', 2000);
insert into stock
values(stock_id_seq.nextval, 'B5스프링 공책', 0, 'product', 3000);
insert into stock
values(stock_id_seq.nextval, '제도샤프', 760, 'goods', 1000);
insert into stock
values(stock_id_seq.nextval, '지우개', 170, 'goods', 300);

insert into manufacturer
values('호남제지', '010-8788-6569', '부산 강서구', 'Cave Johnson');
insert into manufacturer
values('동의문구', '010-1234-1234', '부산 강서구', '김동의');
insert into manufacturer
values('ERD Chemical', '010-3322-2134', '울산 북구', '한지우');

insert into supply(stock_id, mfr_name, quantity)
values(1, '호남제지', 3000);
insert into supply(stock_id, mfr_name, quantity)
values(2, '호남제지', 2000);
insert into supply(stock_id, mfr_name, quantity)
values(3, '호남제지', 3000);
insert into supply(stock_id, mfr_name, quantity)
values(4, '호남제지', 2500);
insert into supply(stock_id, mfr_name, quantity)
values(5, '호남제지', 1500);
insert into supply(stock_id, mfr_name, quantity)
values(6, '호남제지', 3000);
insert into supply(stock_id, mfr_name, quantity)
values(7, '동의문구', 200);
insert into supply(stock_id, mfr_name, quantity)
values(8, '동의문구', 200);
insert into supply(stock_id, mfr_name, quantity)
values(11, '동의문구', 500);
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
values(preset_id_seq.nextval, '스프링노트+샤프 세트');

insert into preset_list
values(2, 10);
insert into preset_list
values(2, 11);

insert into account
values('admin', '0000', '관리자', '관리자', 0);
insert into account
values('manager', '0000', '홍길동', '매니저', 4);
insert into account
values('testid2', '1234', 'testname', '테스터', 8);

insert into menu
values(1, '사용자 권한 설정', 0);
insert into menu
values(2, '메뉴 권한 관리', 9);
insert into menu
values(3, '입출고 등록', 9);
insert into menu
values(4, '내역 조회', 4);
insert into menu
values(5, '제품 관리', 9);
insert into menu
values(6, '프리셋', 4);
insert into menu
values(7, '매출 조회', 9);
insert into menu
values(8, '재고 분석', 4);