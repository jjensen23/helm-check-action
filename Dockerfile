FROM alpine/helm:3.12.1

LABEL version="1.2.1"
LABEL repository="https://github.com/jjensen23/helm-check-action"
LABEL maintainer="Jeff Jensen"

LABEL com.github.actions.name="GitHub Action for Helm Templates Validation"
LABEL com.github.actions.description="Checks if helm templates are valid"
LABEL com.github.actions.icon="cloud"
LABEL com.github.actions.color="blue"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]