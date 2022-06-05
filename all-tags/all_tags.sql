WITH main AS (SELECT post_year,
                     post_month,
                     tag,
                     month_count -- optional, not needed in main table

FROM (

  SELECT datepart(year,Posts.CreationDate) AS post_year,
         datepart(month,Posts.CreationDate) AS post_month,
         tags.TagName AS tag,
         COUNT(*) AS month_count

  FROM PostTags AS pt
    INNER JOIN Posts
    ON pt.PostId = Posts.Id
    INNER JOIN Tags AS tags
    ON pt.TagId = tags.Id

  WHERE tags.TagName in ('c++','c#','php','python','javascript',
                         'java','swift','kotlin','react-native',
                         'dart', 'objective-c','mysql','postgresql',
                         'mongodb','oracle','db2','sql-server','sqlite',
                         'redis','mariadb','realm','express','django',
                         'ruby-on-rails','laravel','spring','angular',
                         'reactjs','vue.js','julia','octave','scala',
                         'r','matlab','fortran','tensorflow','pytorch',
                         'scipy','keras','scikit-learn','numpy','pandas')
  AND Posts.PostTypeId = 1
  GROUP BY datepart(year,Posts.CreationDate),
           datepart(month,Posts.CreationDate),
           tags.TagName

     ) AS subquery


GROUP BY post_year,
         post_month,
         tag,
         month_count),

sub AS (SELECT datepart(year,Posts.CreationDate) AS post_year,
               datepart(month,Posts.CreationDate) AS post_month,
               count(*) AS total
        FROM Posts WHERE PostTypeId = 1
        GROUP BY datepart(year,Posts.CreationDate),
                 datepart(month,Posts.CreationDate))


SELECT DATEFROMPARTS(main.post_year, main.post_month, 1) AS 'date',
       tag AS 'tag',
       month_count * 100.0 / total AS 'percent'
FROM main INNER JOIN sub ON main.post_year = sub.post_year
                         WHERE main.post_month = sub.post_month
ORDER BY main.post_year,
         main.post_month,
         tag;
