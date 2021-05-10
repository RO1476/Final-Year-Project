## Copyright (C) 2021 rahul
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} myrand2 (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: rahul <rahul@DESKTOP-NFN2AJ9>
## Created: 2021-04-21

function x = myrand2(A, B, n, m)
    x = A + (B - A)*rand(n,m);
  endfunction
