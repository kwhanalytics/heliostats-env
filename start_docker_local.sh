#!/bin/bash
docker rm heliostats_development

# if [ "$1" == "--start-jupyter" ]; then
#     docker-compose -f local-docker-compose.yml run -d --service-ports \
# 	-v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
#         -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
# 	--name heliostats_development data_env && \
#         docker exec -d heliostats_development jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root --NotebookApp.token='kwh' && \
# 	docker exec -it heliostats_development bash
# elif [ "$1" == "" ]; then
#     docker-compose -f local-docker-compose.yml run -d --service-ports \
# 	-v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
# 	-e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
# 	--name heliostats_development data_env && \
# 	docker exec -it heliostats_development bash
# else
#     echo "Invalid arg. Please indicate --start-jupyter if you want to start Jupyter."\
#         "Don't add an argument if you want to exec into bash on docker startup."
# fi
docker-compose -f local-docker-compose.yml run -d --service-ports \
-v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
-e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
--name heliostats_development heliostats_env && \
# docker exec -it heliostats_development sh -c "cd heliostats/ && . heliostats/env/postactivate_dev.sh "
# docker exec -i heliostats_development bash < heliostats/heliostats/env/postactivate_dev.sh
# docker exec -it heliostats_development bash
# docker exec heliostats_development sh -c "cd heliostats/ && . heliostats/env/postactivate_dev.sh "
docker exec -it heliostats_development bash


# docker exec -it heliostats_development cd ~/heliostats
# docker exec -it heliostats_development source heliostats/env/postactivate_dev.sh 
# docker run --rm -ti _image_name_ bash -c 'heliostats/heliostats/env/postactivate_dev.sh '
# cd ~/heliostats
# source heliostats/env/postactivate_dev.sh