library(redux)
# sudo apt install -y libhiredis-dev

r <- redux::hiredis(url = 'redis://localhost:6379', db=1)

r <- r$SET('foo', 'bar')
