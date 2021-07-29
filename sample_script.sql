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
	('1-1', 'test stage 1', '1', '2019-09-14'),
    ('1-2', 'test stage 2', '1', '2019-09-14'),
    ('2-1', 'test stage 3', '0', NULL),
    ('2-2', 'test stage 4', '1', '2019-09-15');

insert into project_stage values 
	('1', '1-1'),
	('1', '1-2'),
	('2', '2-1'),
	('2', '2-2');
    
insert into worker values 
	('1', 'Vasya', 'Vasilyev', '1'),
	('2', 'Stepan', 'Stepanov', '2'),
    ('3', 'Fedor', 'Fedorov', '3');

insert into payment values 
	('1-1', '100', '1', NULL),
	('1-2', '150', '2', NULL),
    ('2-1', '15', '1', '1'),
    ('2-2', '20', '2', '2'),
    ('2-1', '10', '2', '2'),
    ('2-1', '10', '1', '3'),
    ('2-2', '10', '1', '3');

insert into working_period values 
	('1', '2-1', '2019-09-14T18:00:00', '2019-09-14T19:00:00'),
	('1', '2-1', '2019-09-14T20:00:00', '2019-09-14T21:00:00'),
	('2', '2-2', '2019-09-14T18:00:00', '2019-09-14T21:00:00'),
    ('2', '2-1', '2019-09-13T08:00:00', '2019-09-13T10:00:00'),
    ('2', '2-2', '2019-09-14T18:00:00', '2019-09-14T19:00:00'),
    ('3', '2-1', '2019-09-14T20:00:00', '2019-09-14T21:00:00'),
    ('3', '2-2', '2019-09-13T18:00:00', '2019-09-13T21:00:00');
    
insert into salary values 
	('1', '300', '2'),
    ('2', '55', '2'),
	('3', '6', '1');*/

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
    
#подсчет зарплаты работника по часам

/*select sum(timestampdiff(hour, working_period.start, working_period.finish) * salary.size * currency.ratio) as sum, '$' from worker
	inner join working_period on working_period.worker_id = worker.id
    inner join salary on salary.worker_id = worker.id
    inner join currency on salary.currency_id = currency.id
    where worker.id = '3' and working_period.start between '2019-09-01' and '2019-10-01';*/
    
#подсчет зарплаты работника за месяц

/*select (salary.size * currency.ratio) as sum, '$' from salary
	inner join worker on worker.id = salary.worker_id
    inner join currency on currency.id = salary.currency_id
    where worker.id = '1';*/
    
#подсчет зарплаты работника за этап

/*select sum(salary.size * currency.ratio) as sum, '$'  from worker as w
	inner join salary on salary.worker_id = w.id
    inner join currency on currency.id = salary.currency_id
    where w.id = '2' and exists (
		select * from stage
        inner join working_period on working_period.stage_id = stage.id and working_period.worker_id = '2'
        where stage.completed = '1' and stage.finish_date between '2019-09-01' and '2019-10-01'
	);*/
    
/*select sum(salary.size * currency.ratio) as sum, '$' from worker
	inner join salary on salary.worker_id = worker.id
    inner join currency on currency.id = salary.currency_id
    inner join working_period on working_period.worker_id = worker.id
    inner join stage on working_period.stage_id = stage.id
    where worker.id = '2' and stage.completed = '1' and stage.finish_date between '2019-09-01' and '2019-10-01';*/
    
select sum(salary.size * currency.ratio * count(stage.id in (
	select * from stage
        inner join working_period on working_period.stage_id = stage.id and working_period.worker_id = '2'
        where stage.completed = '1' and stage.finish_date between '2019-09-01' and '2019-10-01'
        group by stage.id))
	) as sum, '$' from worker
	inner join salary on salary.worker_id = worker.id
    inner join currency on currency.id = salary.currency_id
    where worker.id = '2';

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