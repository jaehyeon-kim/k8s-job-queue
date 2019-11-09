library(redux)
# sudo apt install -y libhiredis-dev

r <- redux::hiredis(url = 'redis://localhost:6379/1')

r$SET('foo', 'bar')