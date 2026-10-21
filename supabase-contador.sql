-- Pega esto entero en Supabase > SQL Editor > Run

create table if not exists visitas (
  id int primary key,
  total bigint not null default 0
);

insert into visitas (id, total) values (1, 0) on conflict (id) do nothing;

-- Nadie puede tocar la tabla directamente; solo las dos funciones de abajo
alter table visitas enable row level security;

create or replace function sumar_visita()
returns bigint language sql security definer set search_path = public as $$
  update visitas set total = total + 1 where id = 1 returning total;
$$;

create or replace function leer_visitas()
returns bigint language sql security definer set search_path = public as $$
  select total from visitas where id = 1;
$$;

grant execute on function sumar_visita() to anon;
grant execute on function leer_visitas() to anon;
