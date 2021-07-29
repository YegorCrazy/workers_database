USE test_db_workers;
#SHOW TABLES;

#ввод тестовых данных

/*insert into project values 
	('1', 'test project 1', '1'), 
	('2', 'test project 2', '2');

insert into currency values 
	('1', '$', '1'),
    ('2', '€', '2');

insert into stage values 
	('1-1', 'test stage 1'),
    ('1-2', 'test stage 2'),
    ('2-1', 'test stage 3'),
    ('2-2', 'test stage 4');

insert into project_stage values 
	('1', '1-1'),
	('1', '1-2'),
	('2', '2-1'),
	('2', '2-2');

insert into payment values 
	('1-1', '100', '1', NULL),
	('1-2', '150', '2', NULL),
    ('2-1', '15', '1', '1'),
    ('2-2', '20', '2', '2'),
    ('2-1', '10', '2', '2');

insert into worker values 
	('1', 'Vasya', 'Vasilyev', '1'),
	('2', 'Stepan', 'Stepanov', '2');

insert into working_period values 
	('1', '2-1', '2019-09-14T18:00:00', '2019-09-14T19:00:00'),
	('1', '2-1', '2019-09-14T20:00:00', '2019-09-14T21:00:00'),
	('2', '2-2', '2019-09-14T18:00:00', '2019-09-14T21:00:00'),
    ('2', '2-1', '2019-09-13T08:00:00', '2019-09-13T10:00:00');*/

#поиск типа оплаты проекта по имени

/*select project.payment_type_id from project 
	inner join project_stage on project.id = project_stage.project_id
    inner join stage on project_stage.stage_id = stage.id
    where stage.name = 'test stage 2';*/
    
#если тип оплаты - по этапам

/*select sum(payment.size * currency.ratio), '$' from payment
	inner join stage  on payment.stage_id = stage.id
    inner join project_stage on stage.id = project_stage.stage_id
    inner join project on project_stage.project_id = project.id
    inner join currency on payment.currency_id = currency.id
    where project.id = '1';*/
    
#если тип оплаты - по часам

/*select working_period.worker_id, stage.id, sum(timestampdiff(hour, working_period.start, working_period.finish)) as period from stage
	inner join working_period on stage.id = working_period.stage_id
    group by working_period.worker_id, stage.id
    order by working_period.worker_id;*/
    
/*select sum(timestampdiff(hour, working_period.start, working_period.finish) * payment.size * currency.ratio) as sum, '$' from working_period
	inner join stage on working_period.stage_id = stage.id
    inner join payment on (working_period.worker_id = payment.worker_id and working_period.stage_id = payment.stage_id)
    inner join currency on payment.currency_id = currency.id
    inner join project_stage on project_stage.stage_id = working_period.stage_id
    inner join project on project_stage.project_id = project.id
    where project.id = '2';*/

#удаление всех таблиц

/*drop table 
	project_stage,
	project,
	payment_type,
	payment,
	working_period,
	salary,
	worker,
	salary_type,
	stage,
	currency;*/