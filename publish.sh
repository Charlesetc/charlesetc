make && cp -r build .build && git checkout master && rm -r * && mv .build/* ./ && rmdir .build && git a && git commit -m "update to master from development" && git push && git checkout development
